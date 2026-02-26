-- snacks.nvim — Replaces Telescope, neo-tree, and adds quality-of-life features
-- https://github.com/folke/snacks.nvim
--

return {
  'folke/snacks.nvim',
  priority = 1000,
  lazy = false,

  ---@type snacks.Config
  opts = {
    --------------------------------------------------------------------------
    -- Picker (replaces Telescope)
    --------------------------------------------------------------------------
    picker = { enabled = true },

    --------------------------------------------------------------------------
    -- Explorer (replaces neo-tree)
    --------------------------------------------------------------------------
    explorer = {
      enabled = true,
      replace_netrw = true,
    },

    --------------------------------------------------------------------------
    -- Quality of life modules
    --------------------------------------------------------------------------
    notifier = { enabled = true },    -- prettier vim.notify
    quickfile = { enabled = true },   -- fast file open (skip plugin init)
    input = { enabled = true },       -- better vim.ui.input (replaces dressing.nvim)
    indent = { enabled = true },      -- indent guides
    scope = { enabled = true },       -- scope detection
    bigfile = { enabled = true },     -- disable features on huge files
    statuscolumn = { enabled = true },-- better status column
    words = { enabled = true },       -- highlight word under cursor (LSP)
  },

  keys = {
    ---------------------------------------------------------------------------
    -- File finding & grep (same keybindings as your old Telescope config)
    ---------------------------------------------------------------------------
    { '<leader>sf', function() Snacks.picker.files() end, desc = '[S]earch [F]iles' },
    { '<leader>sg', function() Snacks.picker.grep() end, desc = '[S]earch by [G]rep' },
    { '<leader>sw', function() Snacks.picker.grep_word() end, desc = '[S]earch current [W]ord', mode = { 'n', 'x' } },
    { '<leader><leader>', function() Snacks.picker.buffers() end, desc = '[ ] Find existing buffers' },
    { '<leader>sh', function() Snacks.picker.help() end, desc = '[S]earch [H]elp' },
    { '<leader>sk', function() Snacks.picker.keymaps() end, desc = '[S]earch [K]eymaps' },
    { '<leader>sd', function() Snacks.picker.diagnostics() end, desc = '[S]earch [D]iagnostics' },
    { '<leader>sr', function() Snacks.picker.resume() end, desc = '[S]earch [R]esume' },
    { '<leader>s.', function() Snacks.picker.recent() end, desc = '[S]earch Recent Files' },
    { '<leader>ss', function() Snacks.picker.pickers() end, desc = '[S]earch [S]elect picker' },
    { '<leader>ds', function() Snacks.picker.lsp_symbols() end, desc = '[D]ocument [S]ymbols' },

    -- Search in current buffer (replaces <leader>/)
    { '<leader>/', function() Snacks.picker.lines() end, desc = '[/] Fuzzily search in current buffer' },

    -- Search in open files (replaces <leader>s/)
    { '<leader>s/', function() Snacks.picker.grep_buffers() end, desc = '[S]earch [/] in Open Files' },

    -- Search neovim config files (replaces <leader>sn)
    { '<leader>sn', function() Snacks.picker.files({ cwd = vim.fn.stdpath('config') }) end, desc = '[S]earch [N]eovim files' },

    ---------------------------------------------------------------------------
    -- Explorer (replaces \ for neo-tree)
    ---------------------------------------------------------------------------
    { '\\', function() Snacks.explorer() end, desc = 'File Explorer' },

    ---------------------------------------------------------------------------
    -- Git pickers (bonus — Telescope required extensions for these)
    ---------------------------------------------------------------------------
    { '<leader>sG', function() Snacks.picker.git_log() end, desc = '[S]earch [G]it log' },
    { '<leader>sB', function() Snacks.picker.git_branches() end, desc = '[S]earch git [B]ranches' },

    ---------------------------------------------------------------------------
    -- Notifications
    ---------------------------------------------------------------------------
    { '<leader>sN', function() Snacks.notifier.show_history() end, desc = '[S]earch [N]otification history' },
  },
}
