" easytags: slow
" vim: set ft=vim:
let g:easytags_async=1
let g:easytags_dynamic_files = 1
let g:easytags_always_enabled=0
let g:easytags_on_cursorhold=0
let g:easytags_events = []

function! UpdateTags()
  execute ":silent !ctags -R --languages=C++ --c++-kinds=+p --fields=+iaS --extras=+q ./"
  execute ":redraw!"
  echohl StatusLine | echo "C/C++ tags updated" | echohl None
endfunction
command! CTags :call UpdateTags()

let $GTAGSLABEL = 'native-pygments'
let $GTAGSCONF = '/usr/local/share/gtags/gtags.conf'

" gutentags 
let g:gutentags_enabled = 0
if g:gutentags_enabled
  let g:gutentags_project_root = ['.root', '.svn', '.git', '.hg', '.project']
  let g:gutentags_define_advanced_commands = 1
  let g:gutentags_file_list_command = 'fd -t f'
  let g:gutentags_ctags_tagfile = 'tags'

  " 将自动生成的 tags 文件全部放入 ~/.cache/tags 目录中，避免污染工程目录
  let s:vim_tags = expand('~/.cache/tags')
  let g:gutentags_cache_dir = s:vim_tags
  if !isdirectory(s:vim_tags)
    silent! call mkdir(s:vim_tags, 'p')
  endif

  " 同时开启 ctags 和 gtags 支持：
  let g:gutentags_modules = []
  if executable('ctags')
    let g:gutentags_modules += ['ctags']
  endif
  if executable('gtags-cscope') && executable('gtags')
    let g:gutentags_modules += ['gtags_cscope']
  endif

  " 配置 ctags 的参数
  let g:gutentags_ctags_extra_args = ['--languages=C++']
  let g:gutentags_ctags_extra_args += ['--c++-kinds=+px']
  let g:gutentags_ctags_extra_args += ['--c-kinds=+px']
  let g:gutentags_ctags_extra_args += ['--fields=+niazS', '--extras=+q']

  " 如果使用 universal ctags 需要增加下面一行，老的 Exuberant-ctags 不能加下一行
  " let g:gutentags_ctags_extra_args += ['--output-format=e-ctags']
  let g:gutentags_ctags_exclude = [
        \ '.git',
        \ '.svn',
        \ '*.git', '*.svg', '*.hg',
        \ '*/tests/*',
        \ 'build',
        \ 'dist',
        \ 'node_modules',
        \ 'vendor',
        \ '*.md',
        \ '*-lock.json',
        \ '*.lock',
        \ '*.json',
        \ '*.min.*',
        \ '*.pyc',
        \ 'tags*',
        \ 'cscope.*',
        \ '*bundle*.js',
        \ '*build*.js',
        \]

  " 禁用 gutentags 自动加载 gtags 数据库的行为
  let g:gutentags_auto_add_gtags_cscope = 1
endif
