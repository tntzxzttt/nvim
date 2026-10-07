return {
  {
    "saghen/blink.cmp",
    opts = function(_, opts)
      opts.keymap = opts.keymap or {}
      -- LazyVim maps <C-y> to select_and_accept without a fallback, which swallows
      -- the key in insert mode; unmap it so it stays usable as a prefix
      opts.keymap["<C-y>"] = false
    end,
  },
}
