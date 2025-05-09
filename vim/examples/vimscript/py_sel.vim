function! SelText() abort
  try
    let a_save = @a
    silent! normal! gv"ay
    return @a
  finally
    let @a = a_save
  endtry
endfunction

command! -nargs=1 -range  TS call SaveTemplate(<q-args>)

fun! SaveTemplate(name)
python <<EOF
import vim
import os

name = vim.eval('a:name')
ft = vim.eval('&ft')
snippets_dir= os.environ['SNIPPETS']
base_dir = os.path.join(snippets_dir,ft)
if not os.path.exists(base_dir):
  os.mkdir(base_dir)

if not '.' in name:
  name += '.' + vim.eval('expand("%:p:e")') 

text = vim.eval('SelText()')
fp = os.path.join(base_dir, name) 
with open(fp, 'wb') as f:
  f.write(text)
EOF
endfun
