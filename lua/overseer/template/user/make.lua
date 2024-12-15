return {
  name = 'make',
  params = {
    args = { type = 'list', delimiter = ' ' },
  },
  builder = function(params)
    return {
      cmd = { 'make' },
      args = params.args,
      components = {
        { 'on_output_quickfix', open = true },
      },
    }
  end,
}
