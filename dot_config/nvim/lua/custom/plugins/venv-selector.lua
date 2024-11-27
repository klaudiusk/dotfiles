return {
  'linux-cultist/venv-selector.nvim',
  dependencies = {
    'neovim/nvim-lspconfig',
    'mfussenegger/nvim-dap',
    'mfussenegger/nvim-dap-python', --optional
    { 'nvim-telescope/telescope.nvim', branch = '0.1.x', dependencies = { 'nvim-lua/plenary.nvim' } },
  },
  opts = {
    anaconda_base_path = '~/.local/miniconda3',
    anaconda_envs_path = '~/.local/miniconda3/envs',
    search_paths = {
      '~/.local/miniconda3/envs/*',
      '~/.cache/pypoetry/virtualenvs/*',
    },
    name = {
      'venv',
      '.venv',
      'env',
      '.env',
      'envs',
      '.envs',
      'virtualenvs',
    },
    dap_enabled = true,
    parents = 0,
  },
  lazy = false,
  branch = 'regexp', -- This is the regexp branch, use this for the new version
  config = function()
    local venv_selector = require('venv-selector')

    local function get_python_command()
      local venv = require('venv-selector').venv()
      if venv then
        -- Check if this is a Poetry virtual environment
        if string.match(venv, 'pypoetry') then
          return string.format('cd $(git rev-parse --show-toplevel) && poetry run ipython')
        end
        -- Fallback to direct ipython path for non-Poetry venvs
        local cmd = venv .. '/bin/ipython'
        return cmd
      end
      return 'ipython' -- Fallback to system ipython if no venv is active
    end

    local function on_venv_activate()
      require('nvim-python-repl').setup({
        spawn_command = {
          python = get_python_command(),
        },
      })
    end

    venv_selector.setup({
      settings = {
        options = {
          on_venv_activate_callback = on_venv_activate,
        },
      },
    })
  end,
  keys = {
    { '<leader>vs', '<cmd>VenvSelect<cr>', desc = 'Select Python VirtualEnv' },
  },
}
