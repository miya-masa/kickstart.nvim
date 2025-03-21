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
      { ',ld', mode = 'n', desc = 'LazyDocker' },
      { ',ht', mode = 'n', desc = 'Htop' },
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

      vim.api.nvim_set_keymap('n', '<leader>ld', '<cmd>lua LazydockerToggle()<CR>', { noremap = true, silent = true })
      vim.api.nvim_set_keymap('n', '<leader>ht', '<cmd>lua HtopToggle()<CR>', { noremap = true, silent = true })
    end,
  },
  {
    'sindrets/diffview.nvim',
    lazy = true,
  },
  {
    'christoomey/vim-tmux-navigator',
    lazy = true,
  },
  {
    'dhruvasagar/vim-table-mode',
    lazy = true,
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
    'diepm/vim-rest-console',
    lazy = true,
    config = function()
      vim.g.vrc_curl_opts = {
        ['-b'] = '/tmp/cookie.txt',
        ['-c'] = '/tmp/cookie.txt',
        ['-L'] = '',
        ['-i'] = '',
        ['--max-time'] = 60,
      }

      vim.g.vrc_auto_format_response_enabled = 1
      vim.g.vrc_show_command = 1
      vim.g.vrc_response_default_content_type = 'application/json'
      vim.g.vrc_auto_format_response_patterns = {
        json = 'jq "."',
        xml = 'tidy -xml -i -',
      }
      vim.g.vrc_trigger = '<Leader><C-o>'
    end,
  },
  {
    'rest-nvim/rest.nvim',
    lazy = true,
    event = { 'BufRead', 'BufNew' },
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
    lazy = true,
  },
  {
    'tpope/vim-abolish',
    lazy = true,
  },
  {
    'stevearc/overseer.nvim',
    lazy = true,
    opts = {},
    config = function()
      require('overseer').setup {
        templates = { 'builtin', 'user.run_script', 'user.go_generate' },
        task_list = {
          bindings = {
            ['K'] = 'ScrollOutputUp',
            ['J'] = 'ScrollOutputDown',
          },
        },
        strategy = 'toggleterm',
      }
      local wk = require 'which-key'
      wk.add {
        { '<Leader>o', group = 'overseer' },
        { '<Leader>or', '<cmd>OverseerRun<CR>', desc = '[O]verseer[R]un' },
        { '<Leader>oc', ':OverseerRunCmd ', desc = '[O]verseer Run [C]md' },
        { '<Leader>om', ':OverseerRunCmd make ', desc = '[O]verseer Run Cmd [M]ake' },
        { '<Leader>os', '<cmd>OverseerRun shell<CR>', desc = '[O]verseer Run [S]hell' },
        { '<Leader>ot', '<cmd>OverseerToggle<CR>', desc = '[O]verseer[T]oggle' },
        { '<Leader>oqw', '<cmd>OverseerQuickAction watch<CR>', desc = '[O]verseer[Q]uickAction [W]atch' },
        { '<Leader>oqr', '<cmd>OverseerQuickAction restart<CR>', desc = '[O]verseer[Q]uickAction Re[S]tart' },
        { 'm ', ':Make ', desc = 'Make' },
      }
      vim.api.nvim_create_user_command('Make', function(params)
        -- Insert args at the '$*' in the makeprg
        local cmd, num_subs = vim.o.makeprg:gsub('%$%*', params.args)
        if num_subs == 0 then
          cmd = cmd .. ' ' .. params.args
        end
        local task = require('overseer').new_task {
          cmd = vim.fn.expandcmd(cmd),
          components = {
            { 'on_output_quickfix', open = not params.bang, open_height = 8 },
            'default',
          },
        }
        task:start()
      end, {
        desc = 'Run your makeprg as an Overseer task',
        nargs = '*',
        bang = true,
      })
    end,
  },
  {
    'stefandtw/quickfix-reflector.vim',
    lazy = true,
  },
  {
    'tmux-plugins/vim-tmux-focus-events',
    lazy = true,
  },
  {
    'vim-jp/vimdoc-ja',
    lazy = true,
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
    lazy = true,
  },
  {
    'ggandor/leap.nvim',
    lazy = true,
    config = function()
      require('leap').create_default_mappings()
    end,
  },
  {
    'folke/trouble.nvim',
    lazy = true,
    dependencies = {
      'nvim-tree/nvim-web-devicons',
    },
    config = function()
      require('trouble').setup {
        -- your configuration comes here
        -- or leave it empty to use the default settings
        -- refer to the configuration section below
      }
    end,
  },
  {
    'kyoh86/vim-go-coverage',
    lazy = true,
  },
  {
    'deris/vim-rengbang',
    lazy = true,
  },
  {
    'mattn/vim-goaddtags',
    lazy = true,
  },
  {
    'jbyuki/venn.nvim',
    lazy = true,
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
    'CopilotC-Nvim/CopilotChat.nvim',
    branch = 'main',
    event = { 'BufRead', 'BufNew' },
    dependencies = {
      { 'zbirenbaum/copilot.lua' }, -- or github/copilot.vim
      { 'nvim-lua/plenary.nvim' }, -- for curl, log wrapper
      { 'MeanderingProgrammer/render-markdown.nvim' },
    },
    keys = {
      {
        '<leader>ccp',
        function()
          local actions = require 'CopilotChat.actions'
          require('CopilotChat.integrations.telescope').pick(actions.prompt_actions())
        end,
        desc = 'CopilotChat - Prompt actions',
      },
      {
        '<leader>ccq',
        function()
          local input = vim.fn.input 'Quick Chat: '
          if input ~= '' then
            require('CopilotChat').ask(input, { selection = require('CopilotChat.select').buffer })
          end
        end,
        desc = 'CopilotChat - Quick chat',
      },
    },
    build = 'make tiktoken', -- Only on MacOS or Linux
    config = function(_, opts)
      local chat = require 'CopilotChat'
      local select = require 'CopilotChat.select'
      local prompts = require 'custom.plugins.chatgpt.copilot-chat-prompts'
      -- Registers copilot-chat filetype for markdown rendering
      require('render-markdown').setup {
        file_types = { 'markdown', 'copilot-chat' },
      }

      opts.highlight_headers = false
      opts.separator = '---'
      opts.error_header = '> [!ERROR] Error'

      opts.model = 'gpt-4o' -- GPT model to use, 'gpt-3.5-turbo' or 'gpt-4'
      opts.context = 'buffers'
      opts.history_path = '~/.copilotchat_history' -- Default path to stored history
      opts.system_prompts = prompts.COPILOT_INSTRUCTIONS
      opts.prompts = {
        Explain = {
          prompt = '> /COPILOT_EXPLAIN\n\n上記のコードの説明をテキストの段落として記述してください。',
        },
        Review = {
          prompt = '/COPILOT_REVIEW 選択したコードをレビューします。',
          callback = function(response, source)
            local ns = vim.api.nvim_create_namespace 'copilot_review'
            local diagnostics = {}
            for line in response:gmatch '[^\r\n]+' do
              if line:find '^line=' then
                local start_line = nil
                local end_line = nil
                local message = nil
                local single_match, message_match = line:match '^line=(%d+): (.*)$'
                if not single_match then
                  local start_match, end_match, m_message_match = line:match '^line=(%d+)-(%d+): (.*)$'
                  if start_match and end_match then
                    start_line = tonumber(start_match)
                    end_line = tonumber(end_match)
                    message = m_message_match
                  end
                else
                  start_line = tonumber(single_match)
                  end_line = start_line
                  message = message_match
                end

                if start_line and end_line then
                  table.insert(diagnostics, {
                    lnum = start_line - 1,
                    end_lnum = end_line - 1,
                    col = 0,
                    message = message,
                    severity = vim.diagnostic.severity.WARN,
                    source = 'Copilot Review',
                  })
                end
              end
            end
            vim.diagnostic.set(ns, source.bufnr, diagnostics)
          end,
        },
        Tests = {
          prompt = '> /COPILOT_GENERATE\n\n上記のコードに対して一連の詳細な単体テスト関数をテーブルテスト形式で作成してください。',
        },
        GoTests = {
          prompt = '> /COPILOT_GENERATE\n\n 上記のコードに対して一連の詳細な単体テスト関数をテーブルテスト形式で作成してください。アサーションは `github.com/stretchr/testify` を使用してください。モックは使用しません。パッケージは `_test` の接尾辞をつけてください。`.` によるセルフインポートも追加してください。関数名は構造体のメソッドはTest<構造体名>_<テスト対象関数名>とし、そうでない場合は Test<テスト対象関数名>としてください。テストの期待値はwantから連想される変数名を使用し、テスト中の実際の値はgotから連想される文字列を使用してください。テストケースの構造体はtestsという変数名を使用し、変数はttとしてください。',
          mapping = '<leader>ccgt',
        },
        TestsWithMock = {
          prompt = '> /COPILOT_GENERATE\n\n上記のコードに対して一連の詳細な単体テスト関数をテーブルテスト形式で作成してください。',
        },
        GoTestsWithMock = {
          prompt = '> /COPILOT_GENERATE\n\n上記のコードに対して一連の詳細な単体テスト関数をテーブルテスト形式で作成してください。アサーションは `github.com/stretchr/testify` を使用してください。必要に応じてモックライブラリとして `go.uber.org/mock/gomock` を使用してください。パッケージは `_test` の接尾辞をつけてください。`.` によるセルフインポートも追加してください。関数名は構造体のメソッドはTest<構造体名>_<テスト対象関数名>とし、そうでない場合は Test<テスト対象関数名>としてください。テストの期待値はwantから連想される変数名を使用し、取得した値はgotから連想される文字列を使用してください。テストケースの構造体はtestsという変数名を使用し、変数はttとしてください。',
        },
        GoTestsValidator = {
          prompt = '> /COPILOT_GENERATE\n\n上記の構造体のコードに対して、github.com/go-playground/validator/v10 を使用したバリデーションの網羅的な単体テストを書いてください。パッケージは `_test` の接尾辞をつけてください。`.` によるセルフインポートも追加してください。関数名は構造体のメソッドはTest<構造体名>_<テスト対象関数名>とし、そうでない場合は Test<テスト対象関数名>としてください。テストの期待値はwantから連想される変数名を使用し、取得した値はgotから連想される文字列を使用してください。テストケースの構造体はtestsという変数名を使用し、変数はttとしてください。',
        },
        GoBench = {
          prompt = '> /COPILOT_GENERATE\n\n上記のコードに対して一連のベンチマークテストを作成してください。',
        },
        Fix = {
          prompt = '> /COPILOT_GENERATE\n\nこのコードには問題があります。バグが修正された状態で表示されるようにコードを書き換えてください。',
        },
        Optimize = {
          prompt = '> /COPILOT_GENERATE\n\n選択したコードを最適化して、パフォーマンスと可読性を向上させてください。',
        },
        Docs = {
          prompt = '> /COPILOT_GENERATE\n\n選択したコードのドキュメントを作成してください。返信は、元のコードとコメントとして追加されたドキュメントを含むコードブロックである必要があります。使用するプログラミング言語に最も適切なドキュメント スタイルを使用します (例: JavaScript の場合は JSDoc、Python の場合は docstrings など)。',
        },
        FixDiagnostic = {
          prompt = 'ファイル内の次の診断問題にご協力ください。:',
          selection = select.diagnostics,
        },
        Commit = {
          prompt = 'commitize の規則に従って、変更に対するコミットメッセージを記述してください。タイトルは最大 50 文字で、メッセージは 72 文字で折り返されるようにしてください。メッセージ全体を gitcommit 言語のコード ブロックでラップします。',
          selection = select.gitdiff,
        },
        CommitStaged = {
          prompt = 'commitize の規則に従って、変更に対するコミットメッセージを記述してください。タイトルは最大 50 文字で、メッセージは 72 文字で折り返されるようにしてください。メッセージ全体を gitcommit 言語のコード ブロックでラップします。',
          selection = function(source)
            return select.gitdiff(source, true)
          end,
        },
        ExtractMethod = {
          prompt = '選択したコードをメソッドに抽出してください。',
        },
      }
      chat.setup(opts)
    end,
    -- opts = {
    --   -- debug = true, -- Enable debugging
    --   -- See Configuration section for rest
    --   --
    --   -- prompts
    -- },
    -- See Commands section for default commands if you want to lazy load on them
  },
  {
    'f-person/git-blame.nvim',
    config = function()
      require('gitblame').setup {
        --Note how the `gitblame_` prefix is omitted in `setup`
        enabled = false,
      }
    end,
  },
  {
    'RaafatTurki/hex.nvim',
    config = function()
      require('hex').setup()
    end,
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
    lazy = true,
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
    lazy = true,
    config = function()
      require('project_nvim').setup {
        -- your configuration comes here
        -- or leave it empty to use the default settings
        -- refer to the configuration section below
      }
    end,
  },
  {
    'Wansmer/treesj',
    keys = { '<space>m', '<space>j', '<space>s' },
    dependencies = { 'nvim-treesitter/nvim-treesitter' }, -- if you install parsers with `nvim-treesitter`
    config = function()
      require('treesj').setup {--[[ your config ]]
      }
    end,
  },
  {
    'romgrk/barbar.nvim',
    dependencies = {
      'lewis6991/gitsigns.nvim', -- OPTIONAL: for git status
      'nvim-tree/nvim-web-devicons', -- OPTIONAL: for file icons
    },
    init = function()
      vim.g.barbar_auto_setup = true
      vim.keymap.set('n', '<A-l>', '<cmd>BufferNext<CR>', { buffer = bufnr })
      vim.keymap.set('n', '<A-h>', '<cmd>BufferPrevious<CR>', { buffer = bufnr })
    end,
    opts = {
      -- lazy.nvim will automatically call setup for you. put your options here, anything missing will use the default:
      -- animation = true,
      -- insert_at_start = true,
      -- …etc.
    },
    version = '^1.0.0', -- optional: only update when a new 1.x version is released
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
    config = function(_, opts)
      require('lsp_signature').setup(opts)
    end,
  },
  {
    'zbirenbaum/copilot.lua',
    cmd = 'Copilot',
    event = 'InsertEnter',
    config = function()
      require('copilot').setup {
        suggestion = { enabled = false },
        panel = { enabled = false },
      }
    end,
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
    config = function()
      require('refactoring').setup()
      vim.keymap.set('x', '<leader>re', ':Refactor extract ')
      vim.keymap.set('x', '<leader>rf', ':Refactor extract_to_file ')
      vim.keymap.set('x', '<leader>rv', ':Refactor extract_var ')
      vim.keymap.set({ 'n', 'x' }, '<leader>ri', ':Refactor inline_var')
      vim.keymap.set('n', '<leader>rI', ':Refactor inline_func')
      vim.keymap.set('n', '<leader>rb', ':Refactor extract_block')
      vim.keymap.set('n', '<leader>rbf', ':Refactor extract_block_to_file')
      -- You can also use below = true here to to change the position of the printf
      -- statement (or set two remaps for either one). This remap must be made in normal mode.
      vim.keymap.set('n', '<leader>rp', function()
        require('refactoring').debug.printf { below = false }
      end)

      -- Print var

      vim.keymap.set({ 'x', 'n' }, '<leader>rd', function()
        require('refactoring').debug.print_var()
      end)
      -- Supports both visual and normal mode

      vim.keymap.set('n', '<leader>rc', function()
        require('refactoring').debug.cleanup {}
      end)
      -- Supports only normal mode
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
      -- {'ibhagwan/fzf-lua'},
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
