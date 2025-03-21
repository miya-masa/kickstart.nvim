return {
  'uga-rosa/translate.nvim',
  lazy = true,
  keys = {
    { '<Leader>tsf', '<Cmd>Translate JA<CR>', mode = { 'n', 'x' } },
    { '<Leader>tsr', '<Cmd>Translate JA --output=replace<CR>', mode = { 'n', 'x' } },
    { '<Leader>tsF', '<Cmd>Translate EN<CR>', mode = { 'n', 'x' } },
    { '<Leader>tsR', '<Cmd>Translate EN --output=replace<CR>', mode = { 'n', 'x' } },
  },
  config = function()
    require('translate').setup {
      default = { command = 'translate_shell' },
      preset = {
        output = {
          split = { append = true },
        },
      },
    }
  end,
}
