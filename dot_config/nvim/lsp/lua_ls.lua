-- ~/.config/nvim/lsp/lua_ls.lua
-- Neovim auto-discovers this file and merges it with nvim-lspconfig defaults.
-- Only overrides go here — cmd, filetypes, root_markers come from lspconfig.
return {
  settings = {
    Lua = {
      completion = {
        callSnippet = 'Replace',
      },
      -- Uncomment to suppress noisy missing-fields warnings:
      -- diagnostics = { disable = { 'missing-fields' } },
    },
  },
}
