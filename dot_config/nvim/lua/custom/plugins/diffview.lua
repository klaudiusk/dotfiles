-- diffview.nvim - Side-by-side diff view with inline editing
-- https://github.com/sindrets/diffview.nvim
--
-- Usage:
--   <leader>gd  Open diff view (unstaged changes vs index)
--   <leader>gD  Close diff view
--   <leader>gh  File history for current file
--   <leader>gH  File history for entire repo
--
-- Inside diffview:
--   <tab>      Next changed file
--   <s-tab>    Previous changed file
--   [x / ]x    Previous / next conflict
--   <leader>co Choose OURS (in merge conflicts)
--   <leader>ct Choose THEIRS
--   <leader>cb Choose BASE
--
-- The diff buffers are real buffers — you can edit inline, save,
-- and your changes are applied. This is what makes it powerful
-- for reviewing AI-generated code.

return {
  'sindrets/diffview.nvim',
  cmd = { 'DiffviewOpen', 'DiffviewFileHistory', 'DiffviewClose' },

  keys = {
    { '<leader>gd', '<cmd>DiffviewOpen<cr>', desc = '[G]it [D]iffview open' },
    { '<leader>gD', '<cmd>DiffviewClose<cr>', desc = '[G]it [D]iffview close' },
    { '<leader>gh', '<cmd>DiffviewFileHistory %<cr>', desc = '[G]it file [H]istory (current file)' },
    { '<leader>gH', '<cmd>DiffviewFileHistory<cr>', desc = '[G]it repo [H]istory' },
  },

  opts = {
    enhanced_diff_hl = true, -- better highlighting of changed words within lines
    use_icons = true,        -- requires nvim-web-devicons (you have it)

    view = {
      default = {
        layout = 'diff2_horizontal', -- side-by-side (left=old, right=new)
        disable_diagnostics = true,  -- less noise while reviewing diffs
      },
    },

    file_panel = {
      listing_style = 'tree',
      win_config = {
        position = 'left',
        width = 35,
      },
    },
  },
}
