-- bootstrap lazy.nvim, LazyVim and your plugins
require("config.lazy")
require("config.commands")

-- Make Snacks hidden files display in white instead of dimmed
vim.api.nvim_set_hl(0, "SnacksPickerDir", { link = "Text" })
vim.api.nvim_set_hl(0, "SnacksPickerPathHidden", { link = "Text" })
vim.api.nvim_set_hl(0, "SnacksPickerGitStatusUntracked", { link = "Special" })

-- Automatically reload Snacks Explorer tree when the explorer window gains focus.
-- NOTE: This relies on the internal snacks.explorer.tree API, which may break on updates.
vim.api.nvim_create_autocmd("BufEnter", {
  callback = function()
    if vim.bo.filetype == "snacks_picker_list" then
      local ok, Tree = pcall(require, "snacks.explorer.tree")
      if ok then
        Tree:refresh(vim.fn.getcwd())
      end
    end
  end,
})

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
