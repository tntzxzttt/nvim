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
  -- hand. Watch the resolved gitdir instead.
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

    local notified = false

    -- snacks.explorer.git and snacks.explorer.watch are internal modules, so a
    -- rename or refactor upstream would raise inside a libuv callback, where
    -- the cause is hard to connect to a stale status column. Report it once and
    -- leave the built-in behaviour (15 minute cache, or R in the explorer).
    local function refresh(root)
      if not _G.Snacks then
        return -- snacks is not on the runtimepath yet
      end

      local ok, err = pcall(function()
        require("snacks.explorer.git").refresh(root)
        require("snacks.explorer.watch").refresh()
      end)

      if ok or notified then
        return
      end

      notified = true

      vim.schedule(function()
        vim.notify(
          ("The explorer gitdir watch failed, so git status will go stale.\nsnacks internals may have changed: %s"):format(
            err
          ),
          vim.log.levels.ERROR,
          { title = "snacks explorer gitdir watch" }
        )
      end)
    end

    local function watch_gitdir()
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

          -- A plain repository keeps its index inside the worktree, where the
          -- built-in watch already sees it.
          if not root or not gitdir or gitdir == root .. "/.git" or watches[gitdir] then
            return
          end

          local watch = { handle = assert(uv.new_fs_event()), timer = assert(uv.new_timer()) }
          watches[gitdir] = watch

          watch.handle:start(gitdir, {}, function(_, file)
            if not file or not triggers[vim.fs.basename(file)] then
              return
            end

            watch.timer:stop()
            watch.timer:start(SETTLE_MS, 0, function()
              refresh(root)
            end)
          end)
        end)
      )
    end

    vim.api.nvim_create_autocmd({ "VimEnter", "DirChanged" }, {
      group = vim.api.nvim_create_augroup("snacks_explorer_gitdir_watch", { clear = true }),
      callback = watch_gitdir,
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
