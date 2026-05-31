return {
  "zbirenbaum/copilot.lua",
  opts = {
    suggestion = {
      enabled = true,
      auto_trigger = true,
      keymap = {
        accept = false, -- handled by blink.cmp
        next = "<M-]>",
        prev = "<M-[>",
      },
    },
    filetypes = {
      markdown = true,
      help = true,
    },
  },
}
