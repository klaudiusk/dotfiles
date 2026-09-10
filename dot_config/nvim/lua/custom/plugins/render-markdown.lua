-- render-markdown.nvim — markdown rendering as an explicit toggle
-- https://github.com/MeanderingProgrammer/render-markdown.nvim
--
-- Markdown buffers open as plain source, and nothing changes with the mode or
-- the cursor line. Rendering is opt-in per buffer:
--   <leader>tm                toggle a rendered reading view for this buffer
--   :RenderMarkdown preview   rendered copy in a side window, source stays raw
--
-- When the reading view is on it stays fully rendered in every mode and on the
-- cursor line too. Toggle it off to edit. Drop the two lines marked (*) below if
-- you prefer the plugin's default hybrid behaviour once toggled on.
--
-- The Avante sidebar (filetype 'Avante') keeps the plugin defaults.

return {
  'MeanderingProgrammer/render-markdown.nvim',
  ft = { 'markdown', 'Avante' },
  cmd = 'RenderMarkdown',

  ---@module 'render-markdown'
  ---@type render.md.UserConfig
  opts = {
    file_types = { 'markdown', 'Avante' },
    overrides = {
      filetype = {
        markdown = {
          enabled = false, -- raw source by default
          render_modes = true, -- (*) render in every mode once toggled on
          anti_conceal = { enabled = false }, -- (*) cursor line rendered too
        },
      },
    },
  },

  keys = {
    {
      '<leader>tm',
      '<cmd>RenderMarkdown buf_toggle<cr>',
      ft = 'markdown',
      desc = '[T]oggle [M]arkdown render',
    },
  },
}
