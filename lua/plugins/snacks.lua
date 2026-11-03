return {
  "folke/snacks.nvim",
  ---@type snacks.Config
  opts = {
    picker = {
      hidden = true,
      ignored = true,
      sources = {
        explorer = {
          hidden = true,
          exclude = {
            "**/.git",
            "**/.tmp",
            "**/.DS_Store",
            "**/*.sock",
          },
          win = {
            list = {
              keys = {
                ["R"] = "explorer_update",
              },
            },
          },
        },
        files = { hidden = true, ignored = true },
      },
    },
  },
  -- snacks.explorer refreshes its git status column from an fs_event on
  -- "<root>/.git", looking for writes to the index. In a git submodule that
  -- path is a gitlink file and the index lives in the superproject's
  -- .git/modules/<name>/, so the event never fires: operations that leave the
  -- worktree untouched (add, commit, checkout, stash) keep showing a stale
  -- status until the 15 minute cache expires or the explorer is refreshed by
  -- hand. Watch the resolved gitdir instead. Even in a plain repository the
  -- built-in watch reacts to index alone and misses operations that only move
  -- the branch (reset --soft), so the gitdir is watched there as well.
  --
  -- The worktree side has a similar gap in every repository: the built-in
  -- watches on the root and on open directories are not recursive, so an
  -- edit made outside nvim inside a collapsed directory goes unnoticed, and
  -- neither the file nor its parent directories change status. Watch the
  -- whole worktree recursively as well.
  init = function()
    local uv = vim.uv or vim.loop
    local watches = {} ---@type table<string, { handle: uv.uv_fs_event_t, timer: uv.uv_timer_t }>

    -- A commit refreshes the index before it moves HEAD, so reading the status
    -- on the first event reports the state from the middle of the operation.
    -- Wait for the writes to stop coming instead.
    local SETTLE_MS = 250

    -- Names whose writes can change what `git status` reports. index.lock is
    -- included because the index write that ends a commit arrives as a lock
    -- event, not as a write to index itself.
    local triggers = { ["index"] = true, ["index.lock"] = true, ["HEAD"] = true, ["ORIG_HEAD"] = true }

    -- Paths under .git change on every git operation. The gitdir watch already
    -- handles the ones that matter.
    local function in_dotgit(file)
      return file == ".git" or vim.startswith(file, ".git/")
    end

    local notified = false

    -- snacks.explorer.git and snacks.explorer.watch are internal modules, so a
    -- rename or refactor upstream would raise inside a libuv callback, where
    -- the cause is hard to connect to a stale status column. Report it once and
    -- leave the built-in behaviour (15 minute cache, or R in the explorer).
    local function report(err)
      if notified then
        return
      end

      notified = true

      vim.schedule(function()
        vim.notify(
          ("The explorer git status watch failed, so git status will go stale.\nsnacks internals may have changed: %s"):format(
            err
          ),
          vim.log.levels.ERROR,
          { title = "snacks explorer git status watch" }
        )
      end)
    end

    local function refresh(root)
      if not _G.Snacks then
        return -- snacks is not on the runtimepath yet
      end

      local ok, err = pcall(function()
        require("snacks.explorer.git").refresh(root)
        require("snacks.explorer.watch").refresh()
      end)

      if not ok then
        report(err)
      end
    end

    -- snacks.explorer.git._update clears status and ignored on every node
    -- before applying a new `git status`, but not dir_status, which is set when
    -- git reports a whole directory ("?? dir/", "!! dir/") and is inherited by
    -- every child without a status of its own. Once that directory is added or
    -- un-ignored, its children keep showing the old status, and R does not help
    -- because it reuses the same nodes; only a restart rebuilds them. Clear
    -- dir_status alongside the other two.
    local function patch_dir_status()
      local ok, err = pcall(function()
        local Git = require("snacks.explorer.git")
        local Tree = require("snacks.explorer.tree")
        local update = Git._update
        assert(type(update) == "function", "snacks.explorer.git._update is missing")

        Git._update = function(cwd, results)
          local before = {} ---@type table<snacks.picker.explorer.Node, string>

          local cleared, clear_err = pcall(function()
            Tree:walk(Tree:find(cwd), function(n)
              if n.dir_status then
                before[n] = n.dir_status
                n.dir_status = nil
              end
            end, { all = true })
          end)

          if not cleared then
            report(clear_err)
          end

          if update(cwd, results) then
            return true
          end

          -- _update compares only status and ignored, so report a change that
          -- touched dir_status alone as well.
          for n, status in pairs(before) do
            if n.dir_status ~= status then
              return true
            end
          end

          return false
        end
      end)

      if not ok then
        report(err)
      end
    end

    -- Start a watch on path that refreshes root once events stop arriving for
    -- SETTLE_MS. should_refresh receives the changed path relative to path,
    -- or nil when the platform cannot tell.
    local function watch(path, root, flags, should_refresh)
      if watches[path] then
        return
      end

      local w = { handle = assert(uv.new_fs_event()), timer = assert(uv.new_timer()) }

      local ok = w.handle:start(path, flags, function(_, file)
        if not should_refresh(file) then
          return
        end

        w.timer:stop()
        w.timer:start(SETTLE_MS, 0, function()
          refresh(root)
        end)
      end)

      if not ok then
        w.handle:close()
        w.timer:close()
        return
      end

      watches[path] = w
    end

    local function watch_repo()
      local cwd = uv.cwd()

      vim.system(
        { "git", "-C", cwd, "rev-parse", "--show-toplevel", "--absolute-git-dir" },
        { text = true },
        vim.schedule_wrap(function(out)
          if out.code ~= 0 then
            return
          end

          local lines = vim.split(vim.trim(out.stdout), "\n")
          local root, gitdir = lines[1], lines[2]

          if not root or not gitdir then
            return
          end

          -- libuv honours recursive only on macOS and Windows. Elsewhere this
          -- duplicates the built-in watch on the root, which is harmless.
          watch(root, root, { recursive = true }, function(file)
            return not file or not in_dotgit(file)
          end)

          -- Watch the gitdir in a plain repository too. The built-in watch on
          -- "<root>/.git" reacts to index alone, so operations that only move
          -- the branch, such as reset --soft, would go unnoticed there.
          watch(gitdir, root, {}, function(file)
            return file ~= nil and triggers[vim.fs.basename(file)] == true
          end)
        end)
      )
    end

    local group = vim.api.nvim_create_augroup("snacks_explorer_git_status_watch", { clear = true })

    vim.api.nvim_create_autocmd({ "VimEnter", "DirChanged" }, {
      group = group,
      callback = watch_repo,
    })

    -- An update that runs before this only leaves a stale dir_status behind,
    -- and the first patched update clears it.
    vim.api.nvim_create_autocmd("User", {
      group = group,
      pattern = "VeryLazy",
      once = true,
      callback = patch_dir_status,
    })
  end,
  keys = {
    {
      "<leader>e",
      function()
        local ok, Snacks = pcall(require, "snacks")
        if not ok then
          vim.notify("snacks.nvim is not available", vim.log.levels.WARN)
          return
        end

        -- Find a Snacks explorer window in the current tab only.
        local function find_explorer_win()
          local current_tab = vim.api.nvim_get_current_tabpage()

          for _, win in ipairs(vim.api.nvim_tabpage_list_wins(current_tab)) do
            local buf = vim.api.nvim_win_get_buf(win)
            local ft = vim.bo[buf].filetype

            if ft == "snacks_picker_list" then
              return win
            end
          end

          return nil
        end

        -- Focus the existing explorer in the current tab or open a new one.
        local function focus_or_open_explorer()
          local explorer_win = find_explorer_win()

          if explorer_win and vim.api.nvim_get_current_win() ~= explorer_win then
            vim.api.nvim_set_current_win(explorer_win)
          else
            Snacks.explorer()
          end
        end

        -- Move to the right window only if one exists in the current layout.
        local function focus_right_if_exists()
          local current_tab = vim.api.nvim_get_current_tabpage()
          local wins = vim.api.nvim_tabpage_list_wins(current_tab)

          if #wins <= 1 then
            return
          end

          local current_winnr = vim.fn.winnr()
          local right_winnr = vim.fn.winnr("l")

          if right_winnr == current_winnr then
            return
          end

          vim.cmd("wincmd l")
        end

        local cur_buf = vim.api.nvim_get_current_buf()
        local cur_ft = vim.bo[cur_buf].filetype

        if cur_ft == "snacks_picker_list" then
          focus_right_if_exists()
        else
          focus_or_open_explorer()
        end
      end,
      desc = "Smart Workspace Tree focus",
      mode = "n",
    },
  },
}
