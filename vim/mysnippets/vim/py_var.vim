def vim2py(name):
  """Get Vim's variable from Python's world"""
  return vim.eval(name)

def py2vim(name):
  """Export Python's variable to Vim world"""
  cmd = "let %s = %s" % (name , repr(eval(name)))
  vim.command(cmd)

def export_var_to_vim(*var_names):
  for var_name in var_names: py2vim(var_name)

def import_var_from_vim(*var_names):
  """Import Vim's variable to Python world"""
  result = {}
  for var_name in var_names: result[var_name] = vim2py(var_name)
  return result
