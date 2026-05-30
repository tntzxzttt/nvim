-- bootstrap lazy.nvim, LazyVim and your plugins
require("config.lazy")

-- Automatically reload a file when it is changed outside of Neovim.
vim.o.autoread = true

-- Trigger CursorHold / CursorHoldI sooner so external changes are picked up quickly.
vim.o.updatetime = 200
vim.api.nvim_create_autocmd({ "CursorHold", "CursorHoldI" }, {
  pattern = "*",
  callback = function()
    -- Avoid running checktime while entering commands in the command-line mode.
    if vim.fn.mode() ~= "c" then
      -- Check whether the current file was modified outside of Neovim and reload it if needed.
      vim.cmd("checktime")
    end
  end,
})
