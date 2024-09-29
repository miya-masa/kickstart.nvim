return {
  'nvimtools/none-ls.nvim',
  config = function()
    local null_ls = require 'null-ls'
    null_ls.setup {
      sources = {
        null_ls.builtins.diagnostics.golangci_lint,
        null_ls.builtins.diagnostics.hadolint,
        null_ls.builtins.diagnostics.rstcheck,
        null_ls.builtins.diagnostics.markdownlint.with {
          args = { '--stdin', '-c', vim.fn.expand '$HOME/.markdownlintrc' },
        },
        null_ls.builtins.diagnostics.sqlfluff.with {
          extra_args = { '--dialect', 'postgres' }, -- change to your dialect
        },
        null_ls.builtins.formatting.sqlfluff.with {
          extra_args = { '--dialect', 'postgres' }, -- change to your dialect
        },
        require 'none-ls.diagnostics.ruff',
      },
    }
  end,
  dependencies = {
    'nvimtools/none-ls-extras.nvim',
  },
}
