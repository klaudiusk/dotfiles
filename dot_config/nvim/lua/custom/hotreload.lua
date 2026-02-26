-- hotreload.lua - Auto-reload buffers when files change externally
--
-- Essential for working with Claude Code (or any external tool that edits files).
-- Neovim's built-in autoread only triggers on certain events. This config
-- adds a timer-based check and more aggressive event handling so you see
-- Claude Code's changes immediately.
--
-- ADD TO: custom/autocommands.lua (or require separately from init.lua)

-- Enable autoread
vim.opt.autoread = true

-- Check for external changes more aggressively
local reload_group = vim.api.nvim_create_augroup('external-file-reload', { clear = true })

-- Trigger checktime on focus/buffer events
vim.api.nvim_create_autocmd({ 'FocusGained', 'BufEnter', 'CursorHold', 'CursorHoldI' }, {
  group = reload_group,
  callback = function()
    if vim.fn.getcmdwintype() == '' then
      vim.cmd('checktime')
    end
  end,
})

-- Notify when a file has been changed externally
vim.api.nvim_create_autocmd('FileChangedShellPost', {
  group = reload_group,
  callback = function()
    vim.notify('File changed on disk. Buffer reloaded.', vim.log.levels.INFO)
  end,
})

-- Optional: poll for changes every second (useful when Claude Code is actively editing)
-- Uncomment if you find the event-based approach insufficient
-- local timer = vim.uv.new_timer()
-- timer:start(1000, 1000, vim.schedule_wrap(function()
--   if vim.fn.getcmdwintype() == '' then
--     vim.cmd('checktime')
--   end
-- end))
