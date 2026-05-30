return {
  -- Configure TokyoNight to be transparent
  {
    "folke/tokyonight.nvim",
    opts = {
      -- Enable transparency for the main buffer background
      transparent = true,
      styles = {
        -- Make sidebars (like Neo-tree) transparent
        sidebars = "transparent",
        -- Make floating windows (like hover documentation) transparent
        floats = "transparent",
      },
    },
  },
}
