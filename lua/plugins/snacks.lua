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
