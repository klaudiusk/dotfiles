return {
  {
    'rcarriga/nvim-dap-ui',
    dependencies = 'mfussenegger/nvim-dap',
    config = function()
      local dap = require('dap')
      local dapui = require('dapui')
      dapui.setup()
      dap.listeners.after.event_initialized['dapui_config'] = function()
        dapui.open()
      end
      dap.listeners.after.event_terminated['dapui_config'] = function()
        dapui.close()
      end
      dap.listeners.after.event_exited['dapui_config'] = function()
        dapui.close()
      end
    end,
  },
  {
    'mfussenegger/nvim-dap',
    config = function(_, opts)
      vim.keymap.set('n', '<leader>bb', '<cmd> DapToggleBreakpoint <CR>')
    end,
  },
  {
    'mfussenegger/nvim-dap-python',
    df = 'python',
    dependencies = {
      'mfussenegger/nvim-dap',
      'rcarriga/nvim-dap-ui',
    },
    config = function(_, opts)
      local path = '~/.local/share/nvim/mason/packages/debugpy/venv/bin/python'
      require('dap-python').setup(path)
      vim.keymap.set('n', '<leader>de', function()
        require('dap-python').test_method()
      end)
    end,
  },
}
