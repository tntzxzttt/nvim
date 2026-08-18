-- DAP UI layout tuning
-- LazyVim's dap.core extra passes its opts straight to dapui.setup(), and
-- dap-ui replaces the whole `layouts` list when one is given — so the full
-- default layout is restated here with only the sidebar moved to the right.

return {
  {
    "rcarriga/nvim-dap-ui",
    opts = {
      -- NOTE: dap-ui opens layouts in REVERSE order of this list. The bottom
      -- tray is listed first so it opens LAST, as a full-width `botright
      -- split` below everything. Opened the other way around, the tray splits
      -- only under the explorer+main group, wrapping the Snacks explorer
      -- inside a nested column — bufferline then no longer recognises it as
      -- an edge panel and drops its tabline offset.
      layouts = {
        {
          elements = {
            "repl",
            "console",
          },
          size = 10,
          position = "bottom",
        },
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
      },
    },
  },
}
