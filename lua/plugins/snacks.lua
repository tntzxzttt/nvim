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
  keys = {
    {
      "<leader>e",
      function()
        local ok, Snacks = pcall(require, "snacks")
        if not ok then
          vim.notify("snacks.nvim is not available", vim.log.levels.WARN)
          return
        end

        -- Helper: find Snacks explorer window if it exists
        local function find_explorer_win()
          for _, win in ipairs(vim.api.nvim_list_wins()) do
            local buf = vim.api.nvim_win_get_buf(win)
            local ft = vim.bo[buf].filetype
            if ft == "snacks_picker_list" then
              return win
            end
          end
          return nil
        end

        -- Helper: focus existing explorer or open it
        local function focus_or_open_explorer()
          local explorer_win = find_explorer_win()
          if explorer_win and vim.api.nvim_get_current_win() ~= explorer_win then
            vim.api.nvim_set_current_win(explorer_win)
          else
            Snacks.explorer()
          end
        end

        -- Helper: move to the right window ONLY if it truly exists
        local function focus_right_if_exists()
          local wins = vim.api.nvim_list_wins()

          -- If only one window exists, do nothing
          if #wins <= 1 then
            return
          end

          -- Try to get the window ID to the right (without moving)
          -- This checks the layout instead of moving cursor
          local right_win = vim.fn.winnr("l") -- get window number to the right
          if right_win == 1 then
            -- No right window exists
            return
          end

          -- Now it's safe to move
          vim.cmd("wincmd l")
        end

        local cur_buf = vim.api.nvim_get_current_buf()
        local cur_ft = vim.bo[cur_buf].filetype

        if cur_ft == "snacks_picker_list" then
          -- Inside Snacks explorer: move right only when a right window actually exists
          focus_right_if_exists()
        else
          -- Outside explorer: focus or open explorer
          focus_or_open_explorer()
        end
      end,
      desc = "Smart Workspace Tree focus",
      mode = "n",
    },
  },
}
