python << EOS
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
EOS

command! -nargs=1 -bang -complete=customlist,TplFileComplete
                        \ T call InsertFile(<q-args>)

fun! TplFileComplete(A,L,P)
let p = a:A
python <<EOF
import vim
import os
pattern = vim.eval('p')
ft = vim.eval('&ft')

snippets_dir= os.environ['SNIPPETS']
base_dir = snippets_dir
if os.path.exists(os.path.join(base_dir, ft)):
  base_dir = os.path.join(base_dir, ft)

if not pattern:
  pattern = '**/*.*'
if not '*' in pattern:
  pattern = pattern + '*'

files = vim.eval('split(globpath(expand("{0}"), "{1}"), "\n")'.format(base_dir, pattern))
n = len(base_dir) + 1
files = map(lambda x: x[n:], files)
export_var_to_vim("files")
EOF
return files
endfun

function! InsertFile(A)
python <<EOF
import os
import vim
SNIPPETS_DIR = os.environ['SNIPPETS']
fp = vim.eval('a:A')
_, ext = os.path.splitext(fp)
if not ext:
  ft = vim.eval('&ft')
  fp = fp + '.' + ft

if not os.path.exists(fp):
  fp = os.path.join(SNIPPETS_DIR, fp)
if os.path.exists(fp):
  with open(fp, 'rb') as f:
    content = f.readlines()
  r = vim.current.range
  r.append(content)
EOF
endfunc
