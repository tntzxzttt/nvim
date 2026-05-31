return {
  {
    "saghen/blink.cmp",
    opts = function(_, opts)
      opts.signature = vim.tbl_deep_extend("force", opts.signature or {}, {
        enabled = true,
        window = {
          show_documention = true,
          border = "rounded",
        },
      })
    end,
  },
}
