-- native-lsp.lua — Neovim 0.11+ native LSP configuration
--
-- HOW THE NEW SYSTEM WORKS:
-- • Server configs live in ~/.config/nvim/lsp/<name>.lua (auto-discovered)
-- • nvim-lspconfig still provides default cmd/filetypes/root_markers
--   (so you don't have to write those yourself)
-- • mason-lspconfig v2 auto-enables installed servers via vim.lsp.enable()
-- • vim.lsp.config() merges your overrides with lspconfig defaults
-- • No more require('lspconfig').server.setup() calls anywhere
--
-- FILES NEEDED:
--   lsp/lua_ls.lua        — Lua LSP settings
--   lsp/basedpyright.lua  — Python type checker settings
--   lsp/ruff.lua          — Python linting/formatting settings

return {
  -- lazydev: Lua LSP config for Neovim APIs (completion, annotations, signatures)
  {
    'folke/lazydev.nvim',
    ft = 'lua',
    opts = {
      library = {
        { path = 'luvit-meta/library', words = { 'vim%.uv' } },
      },
    },
  },
  { 'Bilal2453/luvit-meta', lazy = true },

  -- nvim-lspconfig: provides default configs for LSP servers
  -- On 0.11+ it registers configs into vim.lsp.config's registry so
  -- vim.lsp.enable() can find them. You never call .setup() directly.
  { 'neovim/nvim-lspconfig', lazy = true },

  -- mason: installs LSP servers, formatters, linters
  {
    'williamboman/mason.nvim',
    opts = {},
  },

  -- mason-tool-installer: ensures specific tools are installed
  {
    'WhoIsSethDaniel/mason-tool-installer.nvim',
    dependencies = { 'williamboman/mason.nvim' },
    opts = {
      ensure_installed = {
        -- LSP servers
        'lua-language-server',
        'basedpyright',
        'ruff',
        -- Formatters
        'stylua',
        -- Debuggers
        'debugpy',
      },
    },
  },

  -- mason-lspconfig: bridges mason and vim.lsp.enable()
  -- With automatic_enable = true (default), it auto-calls vim.lsp.enable()
  -- for every server mason installs that has a config available.
  {
    'mason-org/mason-lspconfig.nvim',
    dependencies = {
      'williamboman/mason.nvim',
      'neovim/nvim-lspconfig',
    },
    opts = {
      -- Automatically call vim.lsp.enable() for installed servers
      automatic_enable = {
        exclude = { 'stylua' },
      },
    },
  },

  -- fidget: LSP status updates in the corner
  { 'j-hui/fidget.nvim', opts = {} },

  -- The LspAttach autocmd for keymaps and behavior
  -- This is a "virtual" plugin spec that just runs config code
  {
    'neovim/nvim-lspconfig',
    event = { 'BufReadPre', 'BufNewFile' },
    config = function()
      -- Global capabilities — broadcast blink.cmp's capabilities to all servers
      local capabilities = vim.lsp.protocol.make_client_capabilities()
      local ok, blink = pcall(require, 'blink.cmp')
      if ok then
        capabilities = vim.tbl_deep_extend('force', capabilities, blink.get_lsp_capabilities())
      end

      -- Apply capabilities to ALL servers via the wildcard config
      vim.lsp.config('*', {
        capabilities = capabilities,
      })

      -- LspAttach: runs every time an LSP client attaches to a buffer
      vim.api.nvim_create_autocmd('LspAttach', {
        group = vim.api.nvim_create_augroup('kickstart-lsp-attach', { clear = true }),
        callback = function(event)
          local map = function(keys, func, desc)
            vim.keymap.set('n', keys, func, { buffer = event.buf, desc = 'LSP: ' .. desc })
          end

          -- Navigation (using snacks.picker if available, fallback to vim.lsp.buf)
          local snacks_ok, Snacks = pcall(require, 'snacks')
          if snacks_ok and Snacks.picker then
            map('gd', function() Snacks.picker.lsp_definitions() end, '[G]oto [D]efinition')
            map('gr', function() Snacks.picker.lsp_references() end, '[G]oto [R]eferences')
            map('gI', function() Snacks.picker.lsp_implementations() end, '[G]oto [I]mplementation')
            map('<leader>D', function() Snacks.picker.lsp_type_definitions() end, 'Type [D]efinition')
            map('<leader>ds', function() Snacks.picker.lsp_symbols() end, '[D]ocument [S]ymbols')
            map('<leader>sS', function() Snacks.picker.lsp_workspace_symbols() end, '[W]orkspace [S]ymbols')
          else
            -- Fallback to built-in LSP if snacks isn't loaded
            map('gd', vim.lsp.buf.definition, '[G]oto [D]efinition')
            map('gr', vim.lsp.buf.references, '[G]oto [R]eferences')
            map('gI', vim.lsp.buf.implementation, '[G]oto [I]mplementation')
            map('<leader>D', vim.lsp.buf.type_definition, 'Type [D]efinition')
            map('<leader>ds', vim.lsp.buf.document_symbol, '[D]ocument [S]ymbols')
            map('<leader>sS', vim.lsp.buf.workspace_symbol, '[W]orkspace [S]ymbols')
          end

          -- Actions (these don't depend on any picker)
          map('<leader>rn', vim.lsp.buf.rename, '[R]e[n]ame')
          map('<leader>ca', vim.lsp.buf.code_action, '[C]ode [A]ction')
          map('gD', vim.lsp.buf.declaration, '[G]oto [D]eclaration')
          map('<leader>ld', vim.diagnostic.open_float, 'Show line diagnostic')

          -- Highlight references under cursor
          local client = vim.lsp.get_client_by_id(event.data.client_id)
          if client and client.supports_method(vim.lsp.protocol.Methods.textDocument_documentHighlight) then
            local highlight_augroup = vim.api.nvim_create_augroup('kickstart-lsp-highlight', { clear = false })
            vim.api.nvim_create_autocmd({ 'CursorHold', 'CursorHoldI' }, {
              buffer = event.buf,
              group = highlight_augroup,
              callback = vim.lsp.buf.document_highlight,
            })
            vim.api.nvim_create_autocmd({ 'CursorMoved', 'CursorMovedI' }, {
              buffer = event.buf,
              group = highlight_augroup,
              callback = vim.lsp.buf.clear_references,
            })
            vim.api.nvim_create_autocmd('LspDetach', {
              group = vim.api.nvim_create_augroup('kickstart-lsp-detach', { clear = true }),
              callback = function(event2)
                vim.lsp.buf.clear_references()
                vim.api.nvim_clear_autocmds({ group = 'kickstart-lsp-highlight', buffer = event2.buf })
              end,
            })
          end

          -- Toggle inlay hints (if supported)
          if client and client.supports_method(vim.lsp.protocol.Methods.textDocument_inlayHint) then
            map('<leader>th', function()
              vim.lsp.inlay_hint.enable(not vim.lsp.inlay_hint.is_enabled({ bufnr = event.buf }))
            end, '[T]oggle Inlay [H]ints')
          end
        end,
      })
    end,
  },
}
