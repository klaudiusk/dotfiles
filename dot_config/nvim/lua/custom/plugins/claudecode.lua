-- claudecode.nvim — Full IDE integration for Claude Code
-- https://github.com/coder/claudecode.nvim
--
-- HOW IT WORKS WITH YOUR TMUX SETUP:
-- This plugin starts a WebSocket MCP server inside Neovim. When Claude Code
-- launches (in your tmux pane), it auto-detects the server and connects.
-- This gives you:
--   • Claude sees your currently open file and cursor position
--   • Claude sees your visual selections
--   • When Claude edits files, you get diff views in Neovim to accept/deny
--   • You can send context to Claude from Neovim
--
-- The terminal provider controls whether you can ALSO open Claude Code
-- inside a Neovim split. With "snacks" or "native", you get both options.
-- With "none", it's pure tmux workflow + WebSocket integration only.
--
-- KEYMAPS:
-- Uses <leader>cc prefix to avoid conflicts with avante.nvim's <leader>a* keymaps.

return {
  'coder/claudecode.nvim',
  dependencies = {
    'folke/snacks.nvim',
  },
  config = true,
  event = 'VeryLazy',

  opts = {
    terminal = {
      split_side = 'right',
      split_width_percentage = 0.40,

      -- "snacks" - uses snacks.nvim terminal (you have snacks installed)
      -- "native" - uses plain Neovim terminal
      -- "none"   - no terminal UI; WebSocket server + tools only (pure tmux)
      provider = 'snacks',
    },

    track_selection = true,
    auto_start = true,
  },

  keys = {
    -- Claude Code group (uses <leader>cc prefix to avoid avante's <leader>a*)
    { '<leader>cc', '<cmd>ClaudeCode<cr>', desc = 'Toggle Claude Code' },
    { '<leader>cf', '<cmd>ClaudeCodeFocus<cr>', desc = 'Focus Claude' },
    { '<leader>cr', '<cmd>ClaudeCode --resume<cr>', desc = 'Resume Claude' },
    { '<leader>cC', '<cmd>ClaudeCode --continue<cr>', desc = 'Continue Claude' },

    -- Send context to Claude
    { '<leader>cb', '<cmd>ClaudeCodeAdd %<cr>', desc = 'Add buffer to Claude' },
    { '<leader>cs', '<cmd>ClaudeCodeSend<cr>', mode = 'v', desc = 'Send selection to Claude' },

    -- Add file from file explorer
    {
      '<leader>cs',
      '<cmd>ClaudeCodeTreeAdd<cr>',
      desc = 'Add file to Claude',
      ft = { 'snacks_picker_list', 'NvimTree', 'neo-tree', 'oil', 'minifiles', 'netrw' },
    },

    -- Diff management
    { '<leader>cA', '<cmd>ClaudeCodeDiffAccept<cr>', desc = 'Accept Claude diff' },
    { '<leader>cD', '<cmd>ClaudeCodeDiffDeny<cr>', desc = 'Deny Claude diff' },

    -- Model selection
    { '<leader>cm', '<cmd>ClaudeCodeSelectModel<cr>', desc = 'Select Claude model' },
  },
}
