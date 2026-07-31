-- DAP UI layout tuning
-- LazyVim's dap.core extra passes its opts straight to dapui.setup(), and
-- dap-ui replaces the whole `layouts` list when one is given — so the full
-- default layout is restated here with only the sidebar moved to the right.

return {
  {
    "rcarriga/nvim-dap-ui",
    opts = {
      layouts = {
        {
          elements = {
            { id = "scopes", size = 0.25 },
            { id = "breakpoints", size = 0.25 },
            { id = "stacks", size = 0.25 },
            { id = "watches", size = 0.25 },
          },
          size = 40,
          position = "right", -- default is "left"
        },
        {
          elements = {
            "repl",
            "console",
          },
          size = 10,
          position = "bottom",
        },
      },
    },
  },
}
