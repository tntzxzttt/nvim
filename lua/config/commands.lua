-- Commands are loaded on startup.
-- Default commands are defined by Neovim and plugins.
--
-- Add any additional user commands here
-- with `vim.api.nvim_create_user_command`
--
-- You can also override or extend existing commands
-- to customize behavior (e.g. replacing `:bd` with a safer variant).

-- Define `:Bdelete[!] [bufnr|file]` as a safer alternative to `:bd`.
-- It uses `Snacks.bufdelete()` to delete the target buffer while
-- preserving the current window layout. Exact `:bd` / `:bdelete`
-- command-line inputs are redirected to this command below.
vim.api.nvim_create_user_command("Bdelete", function(cmd)
  local ok, snacks = pcall(require, "snacks")
  if not ok then
    vim.notify("snacks.nvim is not available", vim.log.levels.WARN)
    return
  end

  local target = {}

  if cmd.args ~= "" then
    local buf = tonumber(cmd.args)
    target = buf and { buf = buf } or { file = cmd.args }
  end

  target.force = cmd.bang
  snacks.bufdelete(target)
end, {
  bang = true,
  nargs = "?",
  complete = "buffer",
  desc = "Delete buffer without changing window layout",
})

-- Built-in lowercase commands can't be replaced directly,
-- so redirect exact command-line uses of :bd/:bdelete to the layout-preserving variant instead.
vim.cmd([[cnoreabbrev <expr> bd getcmdtype() == ':' && getcmdline() ==# 'bd' ? 'Bdelete' : 'bd']])
vim.cmd([[cnoreabbrev <expr> bd! getcmdtype() == ':' && getcmdline() ==# 'bd!' ? 'Bdelete!' : 'bd!']])
vim.cmd([[cnoreabbrev <expr> bdelete getcmdtype() == ':' && getcmdline() ==# 'bdelete' ? 'Bdelete' : 'bdelete']])
vim.cmd([[cnoreabbrev <expr> bdelete! getcmdtype() == ':' && getcmdline() ==# 'bdelete!' ? 'Bdelete!' : 'bdelete!']])
