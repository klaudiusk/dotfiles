return {
  'geg2102/nvim-python-repl',
  dependencies = 'nvim-treesitter',
  ft = { 'python' },
  config = function()
    local python_repl = require('nvim-python-repl')

    -- Configure nvim-python-repl with virtual environment activation
    python_repl.setup({
      spawn_command = {
        python = require('venv-selector').venv(),
      },
      execute_on_send = true,
      vsplit = false,
    })

    vim.keymap.set('n', '<leader>e', python_repl.send_statement_definition, { desc = 'Send line to Python REPL' })
    vim.keymap.set('v', '<leader>e', python_repl.send_visual_to_repl, { desc = 'Send visual selection to Python REPL' })
    vim.keymap.set('n', '<leader>pp', python_repl.open_repl, { desc = 'Toggle Python REPL' })

    vim.keymap.set('n', '<leader>pr', function()
      -- Close existing REPL if it exists
      python_repl.close_repl()
      -- Wait a brief moment before opening a new REPL
      vim.defer_fn(function()
        python_repl.open_repl()
      end, 100)
    end, { desc = 'Restart Python REPL' })
  end,
}
