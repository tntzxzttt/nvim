-- Keymaps are automatically loaded on the VeryLazy event
-- Default keymaps that are always set: https://github.com/LazyVim/LazyVim/blob/main/lua/lazyvim/config/keymaps.lua
-- Add any additional keymaps here

local keymap = vim.keymap
local opts = { noremap = true, silent = true }

-- Move cursor in Insert Mode
keymap.set("i", "<C-p>", "<Up>", opts)
keymap.set("i", "<C-n>", "<Down>", opts)
keymap.set("i", "<C-b>", "<Left>", opts)
keymap.set("i", "<C-f>", "<Right>", opts)
keymap.set("i", "<C-a>", "<Home>", opts)
keymap.set("i", "<C-e>", "<End>", opts)

-- Select all
keymap.set("n", "<C-a>", "gg<S-v>G")

-- Delete the current line (equivalent to `cc` in normal mode)
keymap.set("i", "<C-Return>", "<Esc>cc", { desc = "Delete current line content while staying in insert mode" })

-- New line under the current line
keymap.set("i", "<C-j>", "<Esc>o", { desc = "Insert new line below while staying in insert mode" })

-- Increment / increment
keymap.set("n", "+", "<C-a>")
keymap.set("n", "-", "<C-b>")

-- Delete a word backwards
keymap.set("n", "dw", "vb_d")

-- Jumplist
keymap.set("n", "<C-m>", "<C-i>", opts)

-- Tab
keymap.set("n", "te", ":tabedit", opts)
keymap.set("n", "<tab>", ":tabnext<Return>", opts)
keymap.set("n", "<S-tab>", ":tabprev<Return>", opts)

-- Buffer
keymap.set("n", "<C-]>", ":bnext<Return>", opts)
keymap.set("n", "<C-[>", ":bprev<Return>", opts)

-- Split window
keymap.set("n", "ss", ":split<Return>", opts)
keymap.set("n", "sv", ":vsplit<Return>", opts)

-- Move window
keymap.set("n", "sh", "<C-w>h")
keymap.set("n", "sk", "<C-w>k")
keymap.set("n", "sj", "<C-w>j")
keymap.set("n", "sl", "<C-w>l")

-- Resize window
keymap.set("n", "<C-w><left>", "<C-w><")
keymap.set("n", "<C-w><right>", "<C-w>>")
keymap.set("n", "<C-w><up>", "<C-w>+")
keymap.set("n", "<C-w><down>", "<C-w>-")

-- Diagnostic
keymap.set("n", "<C-l>", function()
  vim.diagnostic.jump({ count = 1 })
end, opts)
keymap.set("n", "<C-h>", function()
  vim.diagnostic.jump({ count = -1 })
end, opts)

-- Plugin: gitsigns (navigate hunk to the previous / next)
keymap.set("n", "<C-;>", function()
  require("gitsigns").nav_hunk("prev")
end)
keymap.set("n", "<C-'>", function()
  require("gitsigns").nav_hunk("next")
end)

-- Copy file path reference for Claude Code and the like
-- Normal: "@lua/config/keymaps.lua"
-- Visual: "@lua/config/keymaps.lua:10-20"
keymap.set({ "n", "v" }, "yc", function()
  local filepath = vim.fn.expand("%:.")
  local mode = vim.fn.mode()
  if mode == "v" or mode == "V" or mode == "\22" then
    local start_line = vim.fn.line("v")
    local end_line = vim.fn.line(".")
    if start_line > end_line then
      start_line, end_line = end_line, start_line
    end
    local ref
    if start_line == end_line then
      ref = "@" .. filepath .. ":" .. start_line
    else
      ref = "@" .. filepath .. ":" .. start_line .. "-" .. end_line
    end
    vim.fn.setreg("+", ref)
    vim.notify("Copied: " .. ref)
    vim.api.nvim_feedkeys(vim.api.nvim_replace_termcodes("<Esc>", true, false, true), "n", true)
  else
    local ref = "@" .. filepath
    vim.fn.setreg("+", ref)
    vim.notify("Copied: " .. ref)
  end
end, { desc = "Copy file path reference to clipboard" })

-- Plugin: Comment (comment in / comment out)
keymap.set("n", "<C-/>", function()
  require("Commnet.api").toggle.linewise.current()
end, opts)
keymap.set("i", "<C-/>", function()
  vim.api.nvim_feedkeys(vim.api.nvim_replace_termcodes("<Esc>", true, false, true), "n", true)
  require("Commnet.api").toggle.linewise.current()
  vim.api.nvim_feedkeys("i", "n", true)
end, opts)
