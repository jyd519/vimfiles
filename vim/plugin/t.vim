" mysnippets template
"
" Author: jyd119@qq.com
" Supports two commands:
"   T *     load snippets
"   TS xxx  save selection as xxx
"
if has('nvim') || exists('g:did_t_vim') || &cp || version < 700
  finish
endif

let g:did_t_vim = 1

if !(has('pythonx') || has('python3'))
  echo "Error: T.vim requires vim compiled with +python"
  finish
endif

if (!exists('g:mysnippets_dir'))
  let g:mysnippets_dir = expand("$SNIPPETS_DIR") 
  if empty(g:mysnippets_dir)
    let g:mysnippets_dir = expand("~/mysnippets")
  endif
endif

pyx << EOF
def vim2py(name):
  """Get Vim's variable from Python's world"""
  return vim.eval(name)

def py2vim(name):
  """Export Python's variable to Vim world"""
  cmd = "let %s = %s" % (name , repr(eval(name)))
  print(cmd)
  vim.command(cmd)

def export_var_to_vim(*var_names):
  for var_name in var_names: 
    py2vim(var_name)

def import_var_from_vim(*var_names):
  """Import Vim's variable to Python world"""
  result = {}
  for var_name in var_names:
    result[var_name] = vim2py(var_name)
  return result
EOF

fun! s:snippet_files(A,L,P)
pyx <<EOF
import vim
import os
pattern = vim.eval('a:A')
ft = vim.eval('&ft')

snippets_dir= vim.eval("g:mysnippets_dir") 
base_dir = snippets_dir
if ft and os.path.exists(os.path.join(base_dir, ft)):
  base_dir = os.path.join(base_dir, ft)

if not pattern:
  pattern = '**/*'
if not '*' in pattern:
  pattern = pattern + '*'
files = vim.eval('split(globpath(expand("{0}"), "{1}"), "\n")'.format(base_dir, pattern))
n = len(base_dir) + 1
files = list(map(lambda x: x[n:], files))
export_var_to_vim("files")
EOF
return files
endfun

function! InsertTemplate(A)
pyx <<EOF
import os
import vim
snippets_dir= vim.eval("g:mysnippets_dir") 
fp = vim.eval('a:A')
_, ext = os.path.splitext(fp)
if not ext:
  ext = vim.eval("expand('%:p:e')")
  if ext:
    fp = fp + '.' + ext 

base_dir = snippets_dir
dst = os.path.join(base_dir, fp)
if not os.path.exists(dst):
  dst = os.path.join(snippets_dir, ft, fp)
if os.path.exists(dst):
  vim.command('r ' + dst)
EOF
endfunc

function! SelText() abort
  try
    let a_save = @a
    silent! normal! gv"ay
    return @a
  finally
    let @a = a_save
  endtry
endfunction

fun! SaveTemplate(name)
pyx <<EOF
import vim
import os

name = vim.eval('a:name')
ft = vim.eval('&ft')
snippets_dir= os.environ['SNIPPETS']
base_dir = os.path.join(snippets_dir,ft)
if not os.path.exists(base_dir):
  os.mkdir(base_dir)

if not '.' in name:
  ext = vim.eval('expand("%:p:e")')
  if ext:
    name += '.' +  ext 

text = vim.eval('SelText()')
fp = os.path.join(base_dir, name) 
with open(fp, 'wt') as f:
  f.write(text)
EOF
endfun

command! -nargs=1 -range -complete=customlist,s:snippet_files TS call SaveTemplate(<q-args>)
command! -nargs=1 -bang -complete=customlist,s:snippet_files T call InsertTemplate(<q-args>)
