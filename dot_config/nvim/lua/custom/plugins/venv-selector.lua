-- venv-selector.nvim v2 — Updated for 2025 rewrite + native LSP
-- https://github.com/linux-cultist/venv-selector.nvim
--
-- MIGRATION:
-- Replace lua/custom/plugins/venv-selector.lua with this file.
--
-- Changes from your old config:
-- • v2 rewrite (regexp branch is now main) — completely different config format
-- • No longer depends on telescope (uses snacks/vim.ui.select automatically)
-- • No longer depends on nvim-lspconfig (uses native vim.lsp.config API)
-- • Can be lazy-loaded on python filetype
-- • Remembers venv per project directory automatically

return {
  'linux-cultist/venv-selector.nvim',
  dependencies = {
    'mfussenegger/nvim-dap',
    'mfussenegger/nvim-dap-python',
  },
  ft = 'python',
  cmd = 'VenvSelect',

  keys = {
    { '<leader>vs', '<cmd>VenvSelect<cr>', desc = 'Select Python VirtualEnv' },
  },

  opts = {
    options = {
      -- Callback when a venv is activated
      on_venv_activate_callback = function()
        -- Update the python-repl if you're still using it
        local ok, python_repl = pcall(require, 'nvim-python-repl')
        if ok then
          local venv = require('venv-selector').venv()
          if venv then
            local python_cmd
            if string.match(venv, 'pypoetry') then
              python_cmd = string.format('cd $(git rev-parse --show-toplevel) && poetry run ipython')
            else
              python_cmd = venv .. '/bin/ipython'
            end
            python_repl.setup({
              spawn_command = { python = python_cmd },
            })
          end
        end
      end,

      enable_default_searches = true,
      enable_cached_venvs = true,
      cached_venv_automatic_activation = true,
      activate_venv_in_terminal = true,
      set_environment_variables = true,
      notify_user_on_venv_activation = false,
    },

    -- Custom search paths for your specific locations
    search = {
      miniconda_envs = {
        command = 'find ~/.local/miniconda3/envs -maxdepth 1 -mindepth 1 -type d',
      },
      poetry_envs = {
        command = 'find ~/.cache/pypoetry/virtualenvs -maxdepth 1 -mindepth 1 -type d',
      },
    },
  },
}
