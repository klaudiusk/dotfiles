-- blink.cmp — Replaces nvim-cmp + LuaSnip + cmp-nvim-lsp + cmp-path + autopairs
-- https://github.com/saghen/blink.cmp
--
-- INSTALLATION:
-- 1. Place this file at lua/custom/plugins/blink-cmp.lua
-- 2. In init.lua, DELETE the entire 'hrsh7th/nvim-cmp' block (~80 lines)
-- 3. In init.lua LSP config, change:
--      require('cmp_nvim_lsp').default_capabilities()
--    to:
--      require('blink.cmp').get_lsp_capabilities()
-- 4. In init.lua LSP dependencies, remove 'hrsh7th/cmp-nvim-lsp'
-- 5. Delete lua/kickstart/plugins/autopairs.lua (blink has auto-brackets)

return {
  'saghen/blink.cmp',
  version = '1.*',
  dependencies = {
    'rafamadriz/friendly-snippets', -- community snippet collection (optional)
  },
  event = 'InsertEnter',

  ---@module 'blink.cmp'
  ---@type blink.cmp.Config
  opts = {
    keymap = {
      -- Preserves your existing nvim-cmp muscle memory
      preset = 'default',                                       -- <C-y> accept, <C-n>/<C-p> navigate
      ['<C-e>'] = { 'show', 'show_documentation', 'hide_documentation' },
      ['<C-b>'] = { 'scroll_documentation_up', 'fallback' },
      ['<C-f>'] = { 'scroll_documentation_down', 'fallback' },
      ['<C-l>'] = { 'snippet_forward', 'fallback' },            -- was luasnip.expand_or_jump()
      ['<C-h>'] = { 'snippet_backward', 'fallback' },           -- was luasnip.jump(-1)
    },

    appearance = {
      nerd_font_variant = 'mono', -- you have nerd fonts (vim.g.have_nerd_font = true)
    },

    completion = {
      accept = {
        auto_brackets = { enabled = true }, -- replaces nvim-autopairs for completions
      },
      documentation = {
        auto_show = true,
        auto_show_delay_ms = 200,
      },
    },

    signature = {
      enabled = true, -- shows function signatures as you type arguments
    },

    sources = {
      default = { 'lsp', 'path', 'snippets', 'buffer' },
      -- lazydev integration for Lua LSP completions in your nvim config
      per_filetype = {
        lua = { inherit_defaults = true, 'lazydev' },
      },
      providers = {
        lazydev = {
          name = 'LazyDev',
          module = 'lazydev.integrations.blink',
          score_offset = 100,
        },
      },
    },

    fuzzy = {
      implementation = 'prefer_rust_with_warning', -- fast Rust fuzzy matcher
    },
  },
}
