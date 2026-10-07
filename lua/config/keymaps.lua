-- Keymaps are automatically loaded on the VeryLazy event
-- Default keymaps that are always set: https://github.com/LazyVim/LazyVim/blob/main/lua/lazyvim/config/keymaps.lua
-- Add any additional keymaps here

local keymap = vim.keymap
local opts = { noremap = true, silent = true }

-- Suppress keys that have no action in Insert / Cmdline mode
-- Neovim recognizes these key codes but has nothing to do with them, so it
-- inserts the key name itself as text (e.g. "<S-Del>"). Add more as they show up.
keymap.set({ "i", "c" }, "<S-Del>", "<Nop>", opts)

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
keymap.set("n", "<C-c>", "<cmd>Bdelete<CR>", { desc = "Delete buffer without changing window layout" })
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

-- LSP (reload buffers changed on disk, then restart every running client)
-- Files edited outside Neovim (Bash, Claude Code, git) leave the buffer stale,
-- and a language server type-checks the buffer contents, not the file on disk --
-- so a bare restart reports diagnostics for code that no longer exists.
-- `checktime` reloads such buffers ('autoread' is on by default; a modified
-- buffer still prompts instead of being discarded). Every running client is
-- restarted, not only the ones attached to the current buffer, so that the
-- diagnostics cleared below are all recomputed: `:lsp restart` given client
-- names restarts those clients process-wide, and a restarted client re-attaches
-- to every buffer it served.
keymap.set("n", "<C-S-r>", function()
  local title = { title = "Reload & LSP restart" }

  -- Collect the buffers `checktime` actually reloads, so the notification says
  -- what happened rather than only that the mapping fired
  local reloaded = {}
  local group = vim.api.nvim_create_augroup("keymaps_reload_lsp_restart", { clear = true })
  vim.api.nvim_create_autocmd("FileChangedShellPost", {
    group = group,
    callback = function(args)
      local name = vim.api.nvim_buf_get_name(args.buf)
      table.insert(reloaded, name ~= "" and vim.fn.fnamemodify(name, ":.") or ("[buffer " .. args.buf .. "]"))
    end,
  })
  vim.cmd("checktime")
  vim.api.nvim_del_augroup_by_id(group)

  local reload_msg = #reloaded > 0 and ("Reloaded: " .. table.concat(reloaded, ", ")) or "No buffer changed on disk"

  -- `:lsp restart` reports an error when nothing is running, and with no client
  -- left to publish again there is no point in clearing the diagnostics either
  local pending = {}
  for _, client in ipairs(vim.lsp.get_clients()) do
    pending[client.name] = true
  end
  local names = vim.tbl_keys(pending)
  if #names == 0 then
    vim.notify(reload_msg .. "\nNo LSP client running, nothing to restart", vim.log.levels.WARN, title)
    return
  end
  table.sort(names)

  -- A restarted client gets a new id, hence a new namespace, and the built-in
  -- cleanup only runs once the old process exits (`_on_detach` via `_on_exit`),
  -- so clear the namespaces up front instead of leaving stale diagnostics on
  -- screen until then. Only the LSP ones (`nvim.lsp.<client>.<id>`): nvim-lint
  -- names its namespace after the linter and has no automatic re-trigger, so
  -- clearing it would leave a file looking clean until the next write
  for ns_id, ns in pairs(vim.diagnostic.get_namespaces()) do
    if ns.name:match("^nvim%.lsp%.") then
      vim.diagnostic.reset(ns_id)
    end
  end

  vim.notify(reload_msg .. "\nRestarting: " .. table.concat(names, ", "), vim.log.levels.INFO, title)

  -- The restart is asynchronous, so report each client as it comes back and
  -- count them: a count that stops short of the total means one never returned
  local attach_group = vim.api.nvim_create_augroup("keymaps_reload_lsp_attach", { clear = true })
  local total, back = #names, 0
  vim.api.nvim_create_autocmd("LspAttach", {
    group = attach_group,
    callback = function(args)
      local client = vim.lsp.get_client_by_id(args.data.client_id)
      if not (client and pending[client.name]) then
        return
      end
      pending[client.name] = nil
      back = back + 1
      vim.notify(string.format("%s attached (%d/%d)", client.name, back, total), vim.log.levels.INFO, title)
      if back == total then
        vim.api.nvim_del_augroup_by_id(attach_group)
      end
    end,
  })

  vim.cmd("lsp restart " .. table.concat(names, " "))
end, { desc = "Reload changed buffers and restart LSP clients" })

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
