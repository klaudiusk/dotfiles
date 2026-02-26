-- yank-path.lua - Yank file path with line numbers for Claude Code
--
-- When you want to point Claude Code at specific code, you can yank
-- the file path (with line numbers for selections) and paste it into
-- the Claude Code prompt. This is the "low-tech but effective" way to
-- give Claude context from Neovim.
--
-- ADD TO: custom/keymaps.lua

-- Yank relative file path
vim.keymap.set('n', '<leader>yr', function()
  local path = vim.fn.fnamemodify(vim.fn.expand('%'), ':~:.')
  vim.fn.setreg('+', path)
  vim.notify('Yanked: ' .. path, vim.log.levels.INFO)
end, { desc = '[Y]ank [R]elative path' })

-- Yank absolute file path
vim.keymap.set('n', '<leader>ya', function()
  local path = vim.fn.expand('%:p')
  vim.fn.setreg('+', path)
  vim.notify('Yanked: ' .. path, vim.log.levels.INFO)
end, { desc = '[Y]ank [A]bsolute path' })

-- Yank relative path with line number
vim.keymap.set('n', '<leader>yl', function()
  local path = vim.fn.fnamemodify(vim.fn.expand('%'), ':~:.')
  local line = vim.fn.line('.')
  local result = path .. ':' .. line
  vim.fn.setreg('+', result)
  vim.notify('Yanked: ' .. result, vim.log.levels.INFO)
end, { desc = '[Y]ank path with [L]ine' })

-- Yank relative path with line range (visual mode)
vim.keymap.set('v', '<leader>yl', function()
  local path = vim.fn.fnamemodify(vim.fn.expand('%'), ':~:.')
  local start_line = vim.fn.line('v')
  local end_line = vim.fn.line('.')
  if start_line > end_line then
    start_line, end_line = end_line, start_line
  end
  local result = path .. ':' .. start_line .. '-' .. end_line
  vim.fn.setreg('+', result)
  vim.notify('Yanked: ' .. result, vim.log.levels.INFO)
end, { desc = '[Y]ank path with [L]ine range' })
