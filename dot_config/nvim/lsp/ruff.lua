-- ~/.config/nvim/lsp/ruff.lua
-- Linting + formatting + import sorting for Python (replaces black, isort, ruff CLI).
-- Runs alongside basedpyright — ruff handles diagnostics/formatting,
-- basedpyright handles types/completions/hover.
return {
  init_options = {
    settings = {
      lineLength = 88,
    },
  },

  -- Disable hover — basedpyright's hover is better
  on_attach = function(client, _)
    client.server_capabilities.hoverProvider = false
  end,
}
