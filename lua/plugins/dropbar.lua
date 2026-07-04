-- lua/plugins/dropbar.lua
return {
  {
    "Bekaboo/dropbar.nvim",
    opts = function()
      vim.api.nvim_set_hl(0, "DropBarFileNameBold", {
        bold = true,
      })

      local sources = require("dropbar.sources")

      local bold_file_path_source = {
        get_symbols = function(buf, win, cursor)
          local symbols = sources.path.get_symbols(buf, win, cursor)

          if symbols and #symbols > 0 then
            symbols[#symbols].name_hl = "DropBarFileNameBold"
          end

          return symbols
        end,
      }

      return {
        bar = {
          enable = function(buf, win, _)
            return vim.api.nvim_buf_is_valid(buf)
              and vim.api.nvim_win_is_valid(win)
              and vim.fn.win_gettype(win) == ""
              and vim.wo[win].winbar == ""
              and vim.bo[buf].bt == ""
              and vim.api.nvim_buf_get_name(buf) ~= ""
          end,
          sources = function(buf, _)
            local utils = require("dropbar.utils")

            return {
              bold_file_path_source,
              utils.source.fallback({
                sources.lsp,
                sources.treesitter,
              }),
            }
          end,
        },
      }
    end,
  },
}
