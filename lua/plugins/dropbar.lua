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
