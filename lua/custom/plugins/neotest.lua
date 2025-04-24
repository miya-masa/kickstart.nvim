return {
  'nvim-neotest/neotest',
  lazy = true,
  dependencies = {
    'nvim-neotest/nvim-nio',
    'nvim-lua/plenary.nvim',
    'antoinemadec/FixCursorHold.nvim',
    'nvim-treesitter/nvim-treesitter',
    'nvim-neotest/neotest-python',
    'fredrikaverpil/neotest-golang',
  },
  keys = {
    {
      't<C-n>',
      function()
        require('neotest').run.run()
      end,
      desc = 'Run nearest test',
    },
    {
      'ti<C-n>',
      function()
        require('neotest').run.run()
      end,
      desc = 'Run nearest test',
    },
    {
      't<C-m>',
      function()
        require('neotest').run.stop()
      end,
      desc = 'Stop test',
    },
    {
      't<C-f>',
      function()
        vim.cmd 'cd %:p:h'
        require('neotest').run.run(vim.fn.expand '%')
      end,
      desc = 'Run file tests',
    },
    {
      't<C-t>',
      function()
        vim.cmd 'cd %:p:h'
        require('neotest').summary.toggle()
      end,
      desc = 'Toggle test summary',
    },
    {
      't<C-o>',
      function()
        vim.cmd 'cd %:p:h'
        require('neotest').output.open { enter = true }
      end,
      desc = 'Open test output',
    },
    {
      '[n',
      function()
        require('neotest').jump.prev { status = 'failed' }
      end,
      desc = 'Jump to previous failed test',
    },
    {
      ']n',
      function()
        require('neotest').jump.next { status = 'failed' }
      end,
      desc = 'Jump to next failed test',
    },
  },
  config = function()
    -- get neotest namespace (api call creates or returns namespace)
    local neotest_ns = vim.api.nvim_create_namespace 'neotest'
    vim.diagnostic.config({
      virtual_text = {
        format = function(diagnostic)
          local message = diagnostic.message:gsub('\n', ' '):gsub('\t', ' '):gsub('%s+', ' '):gsub('^%s+', '')
          return message
        end,
      },
    }, neotest_ns)
    require('neotest').setup {
      -- your neotest config here
      adapters = {
        require 'neotest-go' {
          args = { '-count=1', '-timeout=60s' },
        },
        require 'neotest-python',
      },
      icons = {
        failed = 'X',
        final_child_indent = ' ',
        final_child_prefix = '╰',
        non_collapsible = '─',
        passed = 'O',
        running = '-',
        running_animated = { '/', '|', '\\', '-', '/', '|', '\\', '-' },
        skipped = 's',
        unknown = 'u',
      },
    }
  end,
}
