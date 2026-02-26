-- ~/.config/nvim/lsp/basedpyright.lua
-- Type checking, completions, hover, go-to-definition for Python.
-- Replaces pyright with the actively-maintained community fork.
return {
  on_init = function(client)
    -- Load project-specific settings from .nvim.lua if present
    -- (preserves your old pyright per-project override pattern)
    local nvim_lua = vim.fn.getcwd() .. '/.nvim.lua'
    if vim.fn.filereadable(nvim_lua) == 1 then
      local config = dofile(nvim_lua)
      if config and config.settings then
        client.config.settings = vim.tbl_deep_extend('force', client.config.settings, config.settings)
        client.notify('workspace/didChangeConfiguration', { settings = client.config.settings })
      end
    end
  end,

  settings = {
    basedpyright = {
      analysis = {
        autoSearchPaths = true,
        diagnosticMode = 'workspace',
        useLibraryCodeForTypes = true,
        typeCheckingMode = 'basic', -- off | basic | standard | strict | all
      },
    },
  },
}
