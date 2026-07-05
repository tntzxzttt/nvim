return {
  "nvim-lualine/lualine.nvim",
  opts = function(_, opts)
    opts.sections.lualine_z = {
      {
        function()
          return os.date("%m/%d/%Y %H:%M")
        end,
        icon = " ",
      },
    }
  end,
}
