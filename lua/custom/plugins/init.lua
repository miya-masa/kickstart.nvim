-- You can add your own plugins here or in other files in this directory!
--  I promise not to create any merge conflicts in this directory :)
--
-- See the kickstart.nvim README for more information
return {
  {
    'kdheepak/lazygit.nvim',
    lazy = true,
    cmd = {
      'LazyGit',
      'LazyGitConfig',
      'LazyGitCurrentFile',
      'LazyGitFilter',
      'LazyGitFilterCurrentFile',
    },
    -- optional for floating window border decoration
    dependencies = {
      'nvim-lua/plenary.nvim',
    },
    -- setting the keybinding for LazyGit with 'keys' is recommended in
    -- order to load the plugin when the command is run for the first time
    keys = {
      { '<leader>lg', '<cmd>LazyGit<cr>', desc = 'LazyGit' },
    },
  },
  {
    'akinsho/toggleterm.nvim',
    lazy = true,
    cmd = {
      'ToggleTerm',
    },
    keys = {
      { '<C-z>', mode = 'n', desc = 'ToggleTerm' },
      {
        '<leader>ld',
        function()
          LazydockerToggle()
        end,
        mode = 'n',
        desc = 'LazyDocker',
      },
      {
        '<leader>ht',
        function()
          HtopToggle()
        end,
        mode = 'n',
        desc = 'Htop',
      },
    },
    version = '*',
    config = function()
      require('toggleterm').setup {
        open_mapping = [[<C-z>]],
        direction = 'horizontal',
        size = 20,
      }

      local lazydocker = require('toggleterm.terminal').Terminal:new {
        cmd = 'lazydocker',
        hidden = true,
        direction = 'float',
      }
      function LazydockerToggle()
        lazydocker:toggle()
      end

      local htop = require('toggleterm.terminal').Terminal:new {
        cmd = 'htop',
        hidden = true,
        direction = 'float',
      }
      function HtopToggle()
        htop:toggle()
      end
    end,
  },
  {
    'sindrets/diffview.nvim',
  },
  {
    'christoomey/vim-tmux-navigator',
  },
  {
    'dhruvasagar/vim-table-mode',
    config = function()
      vim.g.table_mode_disable_mappings = 0
      local wk = require 'which-key'
      wk.add {
        { '<Leader>tm', 'TableModeToggle<CR>', desc = '[T]oggle Table [M]ode' },
        { '<Leader>tr', 'TableModeRealine<CR>', desc = '[T]able Mode [R]ealine' },
        { '<Leader>tt', 'Tableize<CR>', desc = '[T]able Mode [T]ablaize' },
      }
    end,
  },
  {
    'rest-nvim/rest.nvim',
    lazy = true,
    event = { 'BufRead', 'BufNew' },
    dependencies = {
      'nvim-treesitter/nvim-treesitter',
      opts = function(_, opts)
        opts.ensure_installed = opts.ensure_installed or {}
        table.insert(opts.ensure_installed, 'http')
      end,
    },
    config = function()
      vim.api.nvim_create_autocmd('FileType', {
        pattern = 'json',
        callback = function()
          vim.bo.formatexpr = ''
          vim.bo.formatprg = 'jq'
        end,
      })
      vim.api.nvim_create_autocmd('FileType', {
        pattern = 'http',
        callback = function()
          vim.api.nvim_set_keymap('n', '<Leader><C-o>', ':Rest run<CR>', { noremap = true, silent = true })
          -- first load extension
          require('telescope').load_extension 'rest'
          -- then use it, you can also use the `:Telescope rest select_env` command
          vim.api.nvim_set_keymap('n', '<leader>se', ':Telescope rest select_env<CR>', { noremap = true, silent = true, desc = '[S]earch select [E]nv' })
        end,
      })
    end,
  },
  {
    'simeji/winresizer',
  },
  {
    'tpope/vim-abolish',
  },
  {
    'tmux-plugins/vim-tmux-focus-events',
  },
  {
    'vim-jp/vimdoc-ja',
    keys = {
      { 'h', mode = 'c' },
    },
  },
  {
    'johmsalas/text-case.nvim',
    dependencies = { 'nvim-telescope/telescope.nvim' },
    config = function()
      require('textcase').setup {}
      require('telescope').load_extension 'textcase'
      vim.api.nvim_set_keymap('n', 'ga.', '<cmd>TextCaseOpenTelescope<CR>', { desc = 'Telescope' })
      vim.api.nvim_set_keymap('v', 'ga.', '<cmd>TextCaseOpenTelescope<CR>', { desc = 'Telescope' })
    end,
    cmd = {
      -- NOTE: The Subs command name can be customized via the option "substitute_command_name"
      'Subs',
      'TextCaseOpenTelescope',
      'TextCaseOpenTelescopeQuickChange',
      'TextCaseOpenTelescopeLSPChange',
      'TextCaseStartReplacingCommand',
    },
    -- If you want to use the interactive feature of the `Subs` command right away, text-case.nvim
    -- has to be loaded on startup. Otherwise, the interactive feature of the `Subs` will only be
    -- available after the first executing of it or after a keymap of text-case.nvim has been used.
  },
  {
    'folke/trouble.nvim',
    opts = {}, -- for default options, refer to the configuration section for custom setup.
    cmd = 'Trouble',
    keys = {
      {
        '<leader>xx',
        '<cmd>Trouble diagnostics toggle<cr>',
        desc = 'Diagnostics (Trouble)',
      },
      {
        '<leader>xX',
        '<cmd>Trouble diagnostics toggle filter.buf=0<cr>',
        desc = 'Buffer Diagnostics (Trouble)',
      },
      {
        '<leader>cs',
        '<cmd>Trouble symbols toggle focus=false<cr>',
        desc = 'Symbols (Trouble)',
      },
      {
        '<leader>cl',
        '<cmd>Trouble lsp toggle focus=false win.position=right<cr>',
        desc = 'LSP Definitions / references / ... (Trouble)',
      },
      {
        '<leader>xL',
        '<cmd>Trouble loclist toggle<cr>',
        desc = 'Location List (Trouble)',
      },
      {
        '<leader>xQ',
        '<cmd>Trouble qflist toggle<cr>',
        desc = 'Quickfix List (Trouble)',
      },
    },
  },
  {
    'kyoh86/vim-go-coverage',
  },
  {
    'deris/vim-rengbang',
  },
  {
    'mattn/vim-goaddtags',
  },
  {
    'jbyuki/venn.nvim',
    config = function()
      -- venn.nvim: enable or disable keymappings
      function _G.Toggle_venn()
        local venn_enabled = vim.inspect(vim.b.venn_enabled)
        if venn_enabled == 'nil' then
          vim.b.venn_enabled = true
          vim.cmd [[setlocal ve=all]]
          -- draw a line on HJKL keystokes
          vim.api.nvim_buf_set_keymap(0, 'n', 'J', '<C-v>j:VBox<CR>', { noremap = true })
          vim.api.nvim_buf_set_keymap(0, 'n', 'K', '<C-v>k:VBox<CR>', { noremap = true })
          vim.api.nvim_buf_set_keymap(0, 'n', 'L', '<C-v>l:VBox<CR>', { noremap = true })
          vim.api.nvim_buf_set_keymap(0, 'n', 'H', '<C-v>h:VBox<CR>', { noremap = true })
          -- draw a box by pressing "f" with visual selection
          vim.api.nvim_buf_set_keymap(0, 'v', '<CR>', ':VBox<CR>', { noremap = true })
          print 'venn on'
        else
          vim.cmd [[setlocal ve=]]
          vim.api.nvim_buf_del_keymap(0, 'n', 'J')
          vim.api.nvim_buf_del_keymap(0, 'n', 'K')
          vim.api.nvim_buf_del_keymap(0, 'n', 'L')
          vim.api.nvim_buf_del_keymap(0, 'n', 'H')
          vim.api.nvim_buf_del_keymap(0, 'v', '<CR>')
          vim.b.venn_enabled = nil
          print 'venn off'
        end
      end
      vim.api.nvim_set_keymap('n', '<leader>tv', ':lua Toggle_venn()<CR>', { noremap = true })
    end,
  },
  {
    'f-person/git-blame.nvim',
    opts = {
      enabled = false,
    },
  },
  {
    'RaafatTurki/hex.nvim',
    opts = {},
  },
  {
    'chrisgrieser/nvim-spider',
    lazy = true,
    keys = {
      {
        'e',
        "<cmd>lua require('spider').motion('e')<CR>",
        mode = { 'n', 'o', 'x' },
      },
      {
        'w',
        "<cmd>lua require('spider').motion('w')<CR>",
        mode = { 'n', 'o', 'x' },
      },
      {
        'b',
        "<cmd>lua require('spider').motion('b')<CR>",
        mode = { 'n', 'o', 'x' },
      },
    },
  },
  {
    -- 'tpope/vim-dispatch',
    'buoto/gotests-vim',
    config = function()
      vim.g.gotests_template = 'testify'
    end,
  },
  {
    'uga-rosa/translate.nvim',
    keys = {
      {
        '<leader>tse',
        '<cmd>Translate en -output=replace<CR>',
        mode = { 'n', 'x' },
      },
      {
        '<leader>tsj',
        '<cmd>Translate ja -output=replace<CR>',
        mode = { 'n', 'x' },
      },
    },
    config = function()
      require('translate').setup {
        default = {
          command = 'trans',
        },
        preset = {
          output = {
            split = {
              append = true,
            },
          },
        },
      }
    end,
  },
  {
    'ahmedkhalf/project.nvim',
  },
  {
    'Wansmer/treesj',
    keys = { '<space>m', '<space>j', '<space>s' },
    dependencies = { 'nvim-treesitter/nvim-treesitter' }, -- if you install parsers with `nvim-treesitter`
    opts = {},
  },
  {
    'kazhala/close-buffers.nvim',
    config = function()
      require('close_buffers').setup {
        filetype_ignore = { 'neo-tree', 'lazy' },
      }
      vim.api.nvim_set_keymap('n', '<space>bda', [[<CMD>lua require('close_buffers').delete({type = 'hidden'})<CR>]], { noremap = true, silent = true })
      vim.api.nvim_set_keymap('n', '<space>bdt', [[<CMD>lua require('close_buffers').delete({type = 'this'})<CR>]], { noremap = true, silent = true })
    end,
  },
  {
    'stevearc/aerial.nvim',
    opts = {},
    -- Optional dependencies
    dependencies = {
      'nvim-treesitter/nvim-treesitter',
      'nvim-tree/nvim-web-devicons',
    },
    config = function()
      require('aerial').setup {
        -- optionally use on_attach to set keymaps when aerial has attached to a buffer
        on_attach = function(bufnr)
          -- Jump forwards/backwards with '{' and '}'
          vim.keymap.set('n', '{', '<cmd>AerialPrev<CR>', { buffer = bufnr })
          vim.keymap.set('n', '}', '<cmd>AerialNext<CR>', { buffer = bufnr })
        end,
      }
    end,
    vim.keymap.set('n', '<cmd>AerialToggle!<CR>', '<leader>ta', { desc = '[T]oggle [A]erial' }),
  },
  {
    'kevinhwang91/nvim-hlslens',
    config = function()
      require('hlslens').setup()

      local kopts = { noremap = true, silent = true }

      vim.api.nvim_set_keymap('n', 'n', [[<Cmd>execute('normal! ' . v:count1 . 'n')<CR><Cmd>lua require('hlslens').start()<CR>]], kopts)
      vim.api.nvim_set_keymap('n', 'N', [[<Cmd>execute('normal! ' . v:count1 . 'N')<CR><Cmd>lua require('hlslens').start()<CR>]], kopts)
      vim.api.nvim_set_keymap('n', '*', [[*<Cmd>lua require('hlslens').start()<CR>]], kopts)
      vim.api.nvim_set_keymap('n', '#', [[#<Cmd>lua require('hlslens').start()<CR>]], kopts)
      vim.api.nvim_set_keymap('n', 'g*', [[g*<Cmd>lua require('hlslens').start()<CR>]], kopts)
      vim.api.nvim_set_keymap('n', 'g#', [[g#<Cmd>lua require('hlslens').start()<CR>]], kopts)

      vim.api.nvim_set_keymap('n', '<Leader>l', '<Cmd>noh<CR>', kopts)
    end,
  },
  {
    'prochri/telescope-all-recent.nvim',
    dependencies = {
      'nvim-telescope/telescope.nvim',
      'kkharji/sqlite.lua',
      -- optional, if using telescope for vim.ui.select
      'stevearc/dressing.nvim',
    },
    opts = {
      -- your config goes here
    },
  },
  {
    'ray-x/lsp_signature.nvim',
    event = 'VeryLazy',
    opts = {},
  },
  {
    'zbirenbaum/copilot.lua',
    cmd = 'Copilot',
    event = 'InsertEnter',
    opts = {
      suggestion = { enabled = false },
      panel = { enabled = false },
      filetypes = {
        markdown = true,
        help = true,
      },
    },
  },
  {
    'nvimdev/lspsaga.nvim',
    config = function()
      require('lspsaga').setup {
        lightbulb = {
          enable = false,
        },
      }
    end,
    dependencies = {
      'nvim-treesitter/nvim-treesitter', -- optional
      'nvim-tree/nvim-web-devicons', -- optional
    },
  },
  {
    -- Set lualine as statusline
    'nvim-lualine/lualine.nvim',
    -- See `:help lualine.txt`
    opts = {
      options = {
        icons_enabled = true,
        theme = 'catppuccin',
        component_separators = '|',
        section_separators = '',
      },
    },
  },
  {
    'MagicDuck/grug-far.nvim',
    lazy = true,
    config = function()
      require('grug-far').setup {}
    end,
  },
  {
    'ThePrimeagen/refactoring.nvim',
    lazy = true,
    dependencies = {
      'nvim-lua/plenary.nvim',
      'nvim-treesitter/nvim-treesitter',
    },
    keys = {
      { '<leader>re', ':Refactor extract ', mode = 'x', desc = 'Extract to function' },
      { '<leader>rf', ':Refactor extract_to_file ', mode = 'x', desc = 'Extract to file' },
      { '<leader>rv', ':Refactor extract_var ', mode = 'x', desc = 'Extract variable' },
      { '<leader>ri', ':Refactor inline_var', mode = { 'n', 'x' }, desc = 'Inline variable' },
      { '<leader>rI', ':Refactor inline_func', mode = 'n', desc = 'Inline function' },
      { '<leader>rb', ':Refactor extract_block', mode = 'n', desc = 'Extract block' },
      { '<leader>rbf', ':Refactor extract_block_to_file', mode = 'n', desc = 'Extract block to file' },
      {
        '<leader>rp',
        function()
          require('refactoring').debug.printf { below = false }
        end,
        mode = 'n',
        desc = 'Debug print',
      },
      {
        '<leader>rd',
        function()
          require('refactoring').debug.print_var()
        end,
        mode = { 'n', 'x' },
        desc = 'Debug print variable',
      },
      {
        '<leader>rc',
        function()
          require('refactoring').debug.cleanup {}
        end,
        mode = 'n',
        desc = 'Debug cleanup',
      },
    },
    config = function()
      require('refactoring').setup()
    end,
  },
  {
    'MeanderingProgrammer/render-markdown.nvim',
    lazy = true,
    opts = {},
    dependencies = {
      'nvim-treesitter/nvim-treesitter',
      'nvim-tree/nvim-web-devicons',
    }, -- if you prefer nvim-web-devicons
    config = function()
      require('render-markdown').setup {
        file_types = { 'markdown', 'telekasten' },
      }
    end,
  },
  {
    'numToStr/Comment.nvim',
    lazy = true,
    opts = {},
  },
  {
    'jay-babu/mason-null-ls.nvim',
    event = { 'BufReadPre', 'BufNewFile' },
    dependencies = {
      'williamboman/mason.nvim',
      'nvimtools/none-ls.nvim',
    },
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
          require 'none-ls.diagnostics.ruff',
          null_ls.builtins.code_actions.refactoring,
          null_ls.builtins.code_actions.gomodifytags,
        },
      }
      require('mason-null-ls').setup {}
    end,
  },
  -- install with yarn or npm
  {
    'iamcco/markdown-preview.nvim',
    cmd = { 'MarkdownPreviewToggle', 'MarkdownPreview', 'MarkdownPreviewStop' },
    build = 'cd app && yarn install',
    ft = { 'markdown' },
    config = function()
      vim.g.mkdp_filetypes = { 'markdown' }
      vim.g.mkdp_open_to_the_world = 1
      vim.g.mkdp_port = '54321'
    end,
  },
  {
    'AckslD/nvim-neoclip.lua',
    dependencies = {
      -- you'll need at least one of these
      { 'nvim-telescope/telescope.nvim' },
      {
        'ibhagwan/fzf-lua',
        -- optional for icon support
        dependencies = { 'nvim-tree/nvim-web-devicons' },
        -- or if using mini.icons/mini.nvim
        -- dependencies = { "echasnovski/mini.icons" },
        opts = {},
      },
    },
    keys = {
      { '<leader>sc', ':Telescope neoclip<CR>', desc = '[S]earch [C]lipboard' },
    },
    config = function()
      require('neoclip').setup()
    end,
  },
  -- Lua
  {
    'folke/zen-mode.nvim',
    lazy = true,
    opts = {
      -- your configuration comes here
      -- or leave it empty to use the default settings
      -- refer to the configuration section below
    },
  },
  {
    'kristijanhusak/vim-dadbod-ui',
    dependencies = {
      { 'tpope/vim-dadbod', lazy = true },
      { 'kristijanhusak/vim-dadbod-completion', ft = { 'sql', 'mysql', 'plsql' }, lazy = true }, -- Optional
    },
    cmd = {
      'DBUI',
      'DBUIToggle',
      'DBUIAddConnection',
      'DBUIFindBuffer',
    },
    init = function()
      -- Your DBUI configuration
      vim.g.db_ui_use_nerd_fonts = 1
    end,
  },
}
