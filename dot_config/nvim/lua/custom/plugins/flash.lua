-- flash.nvim - Enhanced motions and navigation
-- https://github.com/folke/flash.nvim
--
-- Use `s` to jump anywhere on screen (type chars, pick a label).
-- Use `S` to select by treesitter node.
-- Regular `/` search is left alone — no jump labels interfering.

return {
  'folke/flash.nvim',
  event = 'VeryLazy',

  ---@type Flash.Config
  opts = {
    labels = 'asdfghjklqwertyuiopzxcvbnm',
    modes = {
      -- Do NOT add labels to regular / search
      search = {
        enabled = false,
      },
      -- Enhanced f/F/t/T with labels when there are multiple matches
      char = {
        enabled = true,
        jump_labels = true,
      },
    },
  },

  keys = {
    { 's', mode = { 'n', 'x', 'o' }, function() require('flash').jump() end, desc = 'Flash' },
    { 'S', mode = { 'n', 'x', 'o' }, function() require('flash').treesitter() end, desc = 'Flash Treesitter' },
    { 'r', mode = 'o', function() require('flash').remote() end, desc = 'Remote Flash' },
    { 'R', mode = { 'o', 'x' }, function() require('flash').treesitter_search() end, desc = 'Treesitter Search' },
    -- While in / or ? search, press <C-s> to toggle flash labels on
    { '<c-s>', mode = { 'c' }, function() require('flash').toggle() end, desc = 'Toggle Flash Search' },
  },
}
