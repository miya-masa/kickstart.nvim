return {
  name = 'run-script',
  builder = function()
    local file = vim.fn.expand '%:p'
    local cmd = { file }
    if vim.bo.filetype == 'go' then
      cmd = { 'go', 'run', file }
    end
    return {
      cmd = cmd,
      components = {
        { 'on_output_quickfix', set_diagnostics = true, open = true },
        'on_result_diagnostics_quickfix',
        'default',
      },
    }
  end,
  condition = {
    filetype = { 'sh', 'python', 'go' },
  },
}
