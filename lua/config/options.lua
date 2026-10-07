-- Options are automatically loaded before lazy.nvim startup
-- Default options that are always set: https://github.com/LazyVim/LazyVim/blob/main/lua/lazyvim/config/options.lua
-- Add any additional options here
local opt = vim.opt
opt.number = true
opt.relativenumber = false
opt.numberwidth = 5
opt.signcolumn = "yes:2"
opt.foldcolumn = "1"

-- Show Copilot suggestions as inline ghost text (copilot.lua) instead of
-- blink.cmp completion items, so <Tab> always accepts the visible suggestion
vim.g.ai_cmp = false
