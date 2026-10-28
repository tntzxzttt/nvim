-- Autocmds are automatically loaded on the VeryLazy event
-- Default autocmds that are always set: https://github.com/LazyVim/LazyVim/blob/main/lua/lazyvim/config/autocmds.lua
--
-- Add any additional autocmds here
-- with `vim.api.nvim_create_autocmd`
--
-- Or remove existing autocmds by their group name (which is prefixed with `lazyvim_` for the defaults)
-- e.g. vim.api.nvim_del_augroup_by_name("lazyvim_wrap_spell")

-- Tools running in a pane beside nvim rewrite files while nvim sits unfocused.
-- LazyVim only runs checktime on FocusGained, TermClose and TermLeave, so a
-- buffer catches up when its pane is focused rather than when the file changes.
-- Poll for it instead.
local uv = vim.uv or vim.loop
local CHECKTIME_INTERVAL_MS = 1000

-- Disk mtime as of the last read or write of a buffer. A buffer with unsaved
-- edits is never reloaded, since the reload prompt would interrupt whatever is
-- being typed, so the mtime is what tells us the file moved underneath it.
local function record_disk_mtime(buf)
  local name = vim.api.nvim_buf_get_name(buf)
  local stat = name ~= "" and uv.fs_stat(name) or nil

  if stat then
    vim.b[buf].disk_mtime = stat.mtime.sec + stat.mtime.nsec / 1e9
    vim.b[buf].disk_mtime_reported = nil
  end
end

vim.api.nvim_create_autocmd({ "BufReadPost", "BufWritePost" }, {
  group = vim.api.nvim_create_augroup("reload_files_changed_outside_nvim", { clear = true }),
  callback = function(ev)
    record_disk_mtime(ev.buf)
  end,
})

-- Buffers read before this file is sourced have no baseline yet.
for _, buf in ipairs(vim.api.nvim_list_bufs()) do
  if vim.api.nvim_buf_is_loaded(buf) then
    record_disk_mtime(buf)
  end
end

local function check_buffers_against_disk()
  -- A reload moves text around, which is disruptive mid-insert, and checktime
  -- is not allowed at all while the command line window is open.
  local mode = vim.fn.mode()

  if not mode:match("^[nvV\22]") or vim.fn.getcmdwintype() ~= "" then
    return
  end

  for _, buf in ipairs(vim.api.nvim_list_bufs()) do
    local name = vim.api.nvim_buf_get_name(buf)

    if vim.api.nvim_buf_is_loaded(buf) and vim.bo[buf].buftype == "" and name ~= "" then
      local stat = uv.fs_stat(name)

      -- A file that is gone is left to the focus driven checktime, which
      -- reports it rather than reloading an empty buffer over the content.
      if stat and not vim.bo[buf].modified then
        pcall(vim.cmd, ("checktime %d"):format(buf))
      elseif stat and vim.bo[buf].modified then
        local mtime = stat.mtime.sec + stat.mtime.nsec / 1e9
        local baseline = vim.b[buf].disk_mtime

        if baseline and mtime > baseline and vim.b[buf].disk_mtime_reported ~= mtime then
          vim.b[buf].disk_mtime_reported = mtime
          vim.notify(
            ("%s changed on disk, and this buffer has unsaved changes."):format(vim.fn.fnamemodify(name, ":~:.")),
            vim.log.levels.WARN,
            { title = "File changed outside nvim" }
          )
        end
      end
    end
  end
end

local checktime_timer = assert(uv.new_timer())
checktime_timer:start(CHECKTIME_INTERVAL_MS, CHECKTIME_INTERVAL_MS, vim.schedule_wrap(check_buffers_against_disk))
