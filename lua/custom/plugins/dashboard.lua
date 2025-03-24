return {
  'nvimdev/dashboard-nvim',
  config = function()
    require('dashboard').setup {
      theme = 'hyper',
      config = {
        week_header = {
          enable = true,
        },
        project = {
          enable = false,
        },
        shortcut = {
          { desc = '󰊳 Update', group = '@property', action = 'Lazy update', key = 'u' },
          {
            icon = ' ',
            icon_hl = '@variable',
            desc = 'Files',
            group = 'Label',
            action = 'Telescope git_files',
            key = 'f',
          },
          {
            desc = ' Memo',
            action = 'Telekasten',
            key = 'm',
          },
          {
            desc = ' dotfiles',
            action = 'e ~/dotfiles/README.md',
            key = 'd',
          },
        },
      },
    }
  end,
  dependencies = { 'nvim-tree/nvim-web-devicons' },
}
