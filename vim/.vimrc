"--------------------------------------------------------------------------------
" Configurations for Vim
"   +lua, +python
" Jyd  2014-12-15 12:50
"
" Dependents :
"   ctags
"   jsctags(Tagbar)  npm install -g git://github.com/ramitos/jsctags.git
"--------------------------------------------------------------------------------
set nocompatible              " be iMproved, required
filetype off                  " required

let $VIMFILES=fnamemodify(resolve(expand('<sfile>:p')), ':h')
set rtp+=$VIMFILES

if filereadable(expand('$VIMFILES/.vimrc.bundles'))
  source $VIMFILES/.vimrc.bundles
endif

filetype plugin on
filetype plugin indent on

set ruler
set showcmd
set shiftwidth=2
set tabstop=2
set expandtab
set nowrap
set hlsearch
set incsearch
set number
" set relativenumber
set ignorecase smartcase " Only be case sensitive when search contains uppercase
set nocursorcolumn
set hidden " allow we leave from the current modified buffer
set autoindent
set smartindent
set nobackup nowb noswf
set nowritebackup
set showmatch
set cmdheight=1
set history=100
set foldlevel=4
"set foldcolumn=4
set scrolloff=2
set guioptions-=T
set linespace=6
set encoding=utf-8
set fileencodings=ucs-bom,utf-8,gb2312,cp936,gbk,gb18030
set wildmenu " show a navigable menu for tab completion
set wildmode=list:longest,full
set wildignore+=*/tmp/*,*.so,*.swp,*.zip     " MacOSX/Linux
set wildignore+=*\\tmp\\*,*.swp,*.zip,*.exe  " Windows
set completeopt=menuone,longest,preview
if has("gui_running")
  set ballooneval
  set balloondelay=100
  set cursorline
endif

set t_ti= t_te=

set path=.,./include/**/*,/usr/local/include,/usr/include

" define a group `vimrc` and initialize.
augroup vimrc
  autocmd!
augroup END

" look tags in directory the current file in, and working directory,
" and looking up and up until /
set tags=./tags,tags;/
let g:easytags_dynamic_files = 1
function! UpdateTags()
  execute ":silent !ctags -R –languages=C++ –c++-kinds=+p –fields=+iaS –extra=+q ./"
  execute ":redraw!"
  echohl StatusLine | echo "C/C++ tags updated" | echohl None
endfunction
command! CTags :call UpdateTags()

"persistent undo
set undodir=expand('$VIMFILES/_undodir')
set undolevels=1000 "maximum number of set changes that can be undone
set undoreload=10000 "maximum number lines to save for undo on a buffer reload
set undofile

" copy & paste
set clipboard+=unnamed
vnoremap p "_dP

"status line
set statusline=\ %F%m%r%h\ %w\ %y\ %{getcwd()}\ \ \ Line:\ %l/%L:%c
set laststatus=2

"On mac os x, disable IME when we enter normal mode
if has("mac")
  set noimdisable
  autocmd! vimrc InsertLeave * set imdisable|set iminsert=0
  autocmd! vimrc InsertEnter * set noimdisable|set iminsert=0
endif

set helplang=cn
set langmenu=zh_CN.utf-8
language message zh_CN.utf-8
if has("win32")
  set termencoding=gb2312
  source $VIMRUNTIME/delmenu.vim
  source $VIMRUNTIME/menu.vim
endif

" enable syntax highlighting
syntax on
syntax sync minlines=256

"color pyte
"color DarkBlue
"color solarized
"color darkblack
"color desert256
"color molokai
"color wombat
"color inkpot
if has("gui_running")
  color vc 
else
  "color peachpuff 
  color vc
endif  

"windows size
if has("win32")
  au GUIEnter * simalt ~x
endif

"define leader char
let g:mapleader = ","

"font
"set guifont=Consolas:h12:cANSI
"let s:fontbase="Consolas"
set ambiwidth="double"
let s:fontbase="Bitstream_Vera_Sans_Mono"
if has("mac")
  let s:fontbase="Anonymous_Pro" 
  "let s:fontbase="Source_Code_Pro"
  "let s:fontbase="Ubuntu_Mono"
  let s:fontwide="Hiragino_Sans_GB"
else
  let s:fontbase="Consolas"
  let s:fontwide="YaHei_Consolas_Hybrid"
endif
let s:font_size=12

execute "set guifont=". s:fontbase . ":h" . s:font_size
execute "set guifontwide=" . s:fontwide . ":h" . s:font_size

function! s:IncFontSize()
  let s:font_size+=1
  execute "set guifont=". s:fontbase . ":h" . s:font_size
  execute "set guifontwide=" . s:fontwide . ":h" . s:font_size
  echom s:font_size
endfunction

function! s:DecFontSize()
  let s:font_size-=1
  execute "set guifont=". s:fontbase . ":h" . s:font_size
  execute "set guifontwide=" . s:fontwide . ":h" . s:font_size
  echom s:font_size
endfunction

map <leader>fi :call <SID>IncFontSize()<CR>
map <leader>fo :call <SID>DecFontSize()<CR>

"toggle between interface file and implementation file, etc. .h/.c
map <M-o> :A<CR>

"insert a blank line 
imap <C-Return> <CR><CR><C-o>k<Tab> 

map <leader>s :source %<CR>
map <leader>e :e! $MYVIMRC<CR>

if has("win32")
  source $VIMRUNTIME/mswin.vim
endif

behave mswin

"Smart way to move btw. windows
nnoremap <C-j> <C-W>j
nnoremap <C-k> <C-W>k
nnoremap <C-h> <C-W>h
nnoremap <C-l> <C-W>l

"Use the arrows to something usefull
map <M-right> :bn<cr>
map <M-left> :bp<cr>
map <C-TAB> :bn<cr>

"Switch to current dir
map <leader>cd :lcd %:p:h<cr>:pwd<cr>

"Redefine Omni completion behavior - no auto selection and auto replacement
" By default, Vim will auto select the first candidate when completion is invoked.
" inoremap <C-X><C-O> <C-X><C-O><C-P>

""""""""""""""""""""""""""""""
" Visual Search
""""""""""""""""""""""""""""""
" From an idea by Michael Naumann
function! VisualSearch(direction) range
  let l:saved_reg = @"
  execute "normal! vgvy"
  let l:pattern = escape(@", '\\/.*$^~[]')
  let l:pattern = substitute(l:pattern, "\n$", "", "")
  if a:direction == 'b'
    execute "normal ?" . l:pattern . "^M"
  else
    execute "normal /" . l:pattern . "^M"
  endif
  let @/ = l:pattern
  let @" = l:saved_reg
endfunction

"Basically you press * or # to search for the current selection !! Really useful
vnoremap <silent> * :call VisualSearch('f')<CR>
vnoremap <silent> # :call VisualSearch('b')<CR>

"Tab configuration
map <leader>tn :tabnew %<cr>
map <leader>te :tabedit
map <leader>tc :tabclose<cr>
map <leader>tm :tabmove

"quick switch to normal mode
imap jj <ESC>
imap kk <ESC>

"Move to begin of line / end to line
inoremap <C-e> <Esc>A
inoremap <C-a> <Esc>I
cnoremap <C-a> <C-b>

if has("win32")
  "quick start IE
  nmap <leader>ie :update<cr>:silent !start ie.bat "file://%:p"<cr>
  "quick start firefox
  nmap <leader>ff :update<cr>:silent !start ff.bat "file://%:p"<cr>
  "start chrome
  nmap <leader>ch :update<cr>:silent !start "C:\Program Files (x86)\Google\Chrome\Application\chrome.exe" "file://%:p"<cr>
endif
if has("mac")
  nmap <leader>ch :update<cr>:silent !open -a "Google Chrome" "file://%:p"<cr>
endif

"xml configuration
"-------------------------------------------------------------------------------- 
"let g:xml_syntax_folding = 1
"au BufReadPost *.xsd,*.xml,*.xslt set foldmethod=syntax
au vimrc FileType xml set ep=xmllint\ --format\ --encode\ utf-8\ -

"pascal configuration
"-------------------------------------------------------------------------------- 
au vimrc BufReadPost *.pas,*.dpr set suffixesadd=.pas,.dpr,.txt,.dfm,.inc

"Perl
"-------------------------------------------------------------------------------- 
"au vimrc BufReadPost *.pl so $VIM\perltidy.vim

"javascript
"-------------------------------------------------------------------------------- 
au vimrc FileType javascript setlocal dictionary=$VIMFILES\dict\javascript.dict
au vimrc BufRead,BufNewFile *.js setlocal foldmethod=indent
let g:tern_map_keys=1
let g:tern_show_argument_hints='on_hold'
let g:tern_show_signature_in_pum=1

"vim-json
let g:vim_json_syntax_conceal = 0

"html
"-------------------------------------------------------------------------------- 
"au FileType html set equalprg=tidy\ -utf8\ --indent\ yes\ -q\ -f\ err.txt
command! Thtml :%!tidy -utf8 --indent yes -q -f tidyerr.txt 

"MiniBufExplorer
"-------------------------------------------------------------------------------- 
let g:miniBufExplorerMoreThanOne=0
let g:miniBufExplMapWindowNavVim=1
let g:miniBufExplMapWindowNavArrows=1
let g:miniBufExplMapCTabSwitchBufs=1
let g:miniBufExplModSelTarget=1
let g:miniBufExplMaxSize=2
let g:miniBufExplModSelTarget=1
let g:miniBufExplForceSyntaxEnable=0 "very slow if enabled when editing js file
let g:miniBufExplAutoStart=0 " temporary disabled,  conflicts with session restore

"SuperTab
"-------------------------------------------------------------------------------- 
" let g:SuperTabDefaultCompletionType = "context"
let g:SuperTabDefaultCompletionType='<c-x><c-u><c-p>'

"python
"-------------------------------------------------------------------------------- 
let g:pydiction_location=$VIMFILES . '/plugged/pydiction/complete-dict/'
let g:pydiction_menu_height = 20
au vimrc BufEnter *.py nmap <f9> :!python %<CR>

"NSIS
"-------------------------------------------------------------------------------- 
function! Makensis(arg)
  let l:path = expand("%:p")
  let l:cmd="!cmd /k \"setnsis && makensis " . a:arg . " " . iconv(l:path, "utf8", "cp936") . "\""
  execute l:cmd
endfunction

au vimrc FileType nsis set foldmethod=syntax
au vimrc FileType nsis colorscheme vc
au vimrc FileType nsis nmap <F9> :update<cr>:call Makensis("/DMYDEBUG")<cr>
au vimrc FileType nsis syntax on

"FindFile
"-------------------------------------------------------------------------------- 
let g:FindFileIgnore = ['*.o', '*.pyc', '*/tmp/*', '.svn', '.git', '*.exe', '*.dll']

"Toggle [\], [/]
"-------------------------------------------------------------------------------- 
function! ToggleSlash(independent) range
  let from = ''
  for lnum in range(a:firstline, a:lastline)
    let line = getline(lnum)
    let first = matchstr(line, '[/\\]')
    if !empty(first)
      if a:independent || empty(from)
        let from = first
      endif
      let opposite = (from == '/' ? '\' : '/')
      call setline(lnum, substitute(line, from, opposite, 'g'))
    endif
  endfor
endfunction
command! -bang -range ToggleSlash <line1>,<line2>call ToggleSlash(<bang>1)

" UltiSnips
"-------------------------------------------------------------------------------- 
" Do not use <tab> if you use https://github.com/Valloric/YouCompleteMe.
let g:UltiSnipsExpandTrigger="<C-k>"
let g:UltiSnipsListSnippets="<C-l>"
let g:UltiSnipsJumpForwardTrigger="<C-k>"
let g:UltiSnipsJumpBackwardTrigger="<C-p>"
let g:UltiSnipsEditSplit='vertical'
let g:UltiSnipsSnippetDirectories = ["ultisnips"]
let g:UltiSnipsSnippetsDir=expand('$VIMFILES/mysnippets/ultisnips')
set runtimepath+=$VIMFILES/mysnippets

"neocomplete (requires LUA)
"-------------------------------------------------------------------------------- 
if &rtp =~ 'neocomplete.vim'
  source $VIMFILES/neocomplete.conf  
endif

"neocomplcache
"-------------------------------------------------------------------------------- 
if &rtp =~ 'neocomplcache.vim' 
  source $VIMFILES/neocomplcache.conf
endif

"ctrlp settings
"-------------------------------------------------------------------------------- 
let g:ctrlp_custom_ignore = {
                              \ 'dir':  '\v[\/]\.(git|hg|svn)$',
                              \ 'file': '\v\.(exe|so|dll)$',
                              \ 'link': 'some_bad_symbolic_links',
                              \ }
let g:ctrlp_working_path_mode = ''

"cmake
"-------------------------------------------------------------------------------- 
autocmd vimrc BufRead,BufNewFile *.cmake,CMakeLists.txt,*.cmake.in setf cmake
autocmd vimrc BufRead,BufNewFile *.ctest,*.ctest.in setf cmake

"markdown
"-------------------------------------------------------------------------------- 
let g:vim_markdown_folding_disabled=0
let g:vim_markdown_initial_foldlevel=1

"livedown
"-------------------------------------------------------------------------------- 
let g:livedown_autorun = 0

" should the browser window pop-up upon previewing
let g:livedown_open = 1 

" the port on which Livedown server will run
let g:livedown_port = 1337
map gm :call LivedownPreview()<CR>


" Editing a protected file as 'sudo'
"cmap W w !sudo tee % >/dev/null
command! W w !sudo tee % > /dev/null

" ycm 
"-------------------------------------------------------------------------------- 
let g:ycm_min_num_of_chars_for_completion = 1
let g:ycm_confirm_extra_conf = 0
let g:ycm_use_ultisnips_completer = 1
let g:ycm_filepath_completion_use_working_dir = 1
let g:ycm_collect_identifiers_from_tags_files = 1 
let g:ycm_key_invoke_completion = '<C-Space>'

nnoremap <leader>jd :YcmCompleter GoTo<CR>

let g:ycm_filetype_blacklist = {
      \ 'tagbar' : 1,
      \ 'qf' : 1,
      \ 'notes' : 1,
      \ 'markdown' : 1,
      \ 'unite' : 1,
      \ 'vimwiki' : 1,
      \ 'pandoc' : 1,
      \ 'infolog' : 1,
      \ 'mail' : 1
      \}

" multiple_cursors and YCM
function! Multiple_cursors_before()
    let g:ycm_auto_trigger = 0
endfunction
 
function! Multiple_cursors_after()
    let g:ycm_auto_trigger = 1
endfunction

" jedi settings
let g:jedi#completions_enabled=0

" tagbar settings
"-------------------------------------------------------------------------------- 
map <leader>t :TagbarToggle<cr>
if filereadable($VIMFILES . '/tagbar.conf')
    source $VIMFILES/tagbar.conf
endif


" vim-session settings
"-------------------------------------------------------------------------------- 
let g:session_autosave='no'
let g:session_autoload='no'

" airline settings
"-------------------------------------------------------------------------------- 
let g:airline#extensions#tagbar#enabled = 0
let g:airline_section_b = '%{getcwd()}'
let g:airline#extensions#tmuxline#enabled = 0

"jsbeautify settings
"-------------------------------------------------------------------------------- 
function! s:JBeautify() 
  if &ft ==? 'css'
    call CSSBeautify() 
  elseif &ft ==? 'html' || &ft ==? 'xhtml'
    call HtmlBeautify() 
  elseif &ft ==? 'javascript'
    call JsBeautify()
  elseif &ft ==? 'json'
    call JsonBeautify()
  else
     echom 'JSBeautify: ' . &ft . ' is not supported' 
  endif 
endfunction

nnoremap <leader>jb :call <SID>JBeautify()<CR>
autocmd vimrc FileType javascript vnoremap <buffer>  <c-f> :call RangeJsBeautify()<cr>
autocmd vimrc FileType json vnoremap <buffer> <c-f> :call RangeJsonBeautify()<cr>
autocmd vimrc FileType jsx vnoremap <buffer> <c-f> :call RangeJsxBeautify()<cr>
autocmd vimrc FileType html vnoremap <buffer> <c-f> :call RangeHtmlBeautify()<cr>
autocmd vimrc FileType css vnoremap <buffer> <c-f> :call RangeCSSBeautify()<cr>


"easy switching buffers
"-------------------------------------------------------------------------------- 
nnoremap <leader>b :buffers<CR>:buffer<Space>

" The Silver Searcher
"-------------------------------------------------------------------------------- 
if executable('ag')
  " Use ag over grep
  set grepprg=ag\ --nogroup\ --nocolor\ --column
  set grepformat=%f:%l:%c%m

  "Use ag in CtrlP for listing files. Lightning fast and respects .gitignore
  "let g:ctrlp_user_command = 'ag %s -l --nocolor -g ""'
  "Note that other CtrlP options related to which files get included in the index
  "(g:ctrlp_show_hidden, wildignore, g:ctrlp_custom_ignore, g:ctrlp_max_files, g:ctrlp_max_depth, g:ctrlp_follow_symlinks)
  "do not apply when using g:ctrlp_user_command. 
  let g:ctrlp_user_command = 'ag %s -l --nocolor --nogroup 
         \ --ignore .git --ignore .svn --ignore .hg --ignore .DS_Store 
         \ --ignore .cache --ignore .npm --ignore .idea --ignore .m2 -g ""'
  " ag is fast enough that CtrlP doesn't need to cache
  let g:ctrlp_use_caching = 0
  
  " Ag command 
  command! -nargs=+ -complete=file -bar Ag silent! grep! <args>|cwindow|redraw!
endif


"Man
"-------------------------------------------------------------------------------- 
source $VIMRUNTIME/ftplugin/man.vim
noremap <leader>k :Man <cword><cr>

"vim-easy-align
"-------------------------------------------------------------------------------- 
" Start interactive EasyAlign in visual mode (e.g. vipga)
xmap ga <Plug>(EasyAlign)
" Start interactive EasyAlign for a motion/text object (e.g. gaip)
nmap ga <Plug>(EasyAlign)


"load local customized script
"-------------------------------------------------------------------------------- 
if filereadable(expand("~/.vimrc.local"))
    source ~/.vimrc.local
endif

" Learn to use follow keys
"-------------------------------------------------------------------------------
" ` # $ % ^ * ( ) 0 _ - + w
" W e E t T I o O { } [[ [] ][ ]] [m [M ]m ]M [( ]) [{ ]} | A f F ge gE gg G g0 g^
" g$ g, g; gj gk gI h H j k l L ; ' z. z<CR> z- zz zt zb b B n N M , / ?

" Disable Arrow keys in Escape mode
map <up> <nop>
map <down> <nop>
map <left> <nop>
map <right> <nop>
" Disable Arrow keys in Insert mode
imap <up> <nop>
imap <down> <nop>
imap <left> <nop>
imap <right> <nop>

nmap <silent> <RIGHT> :cnext<CR>
nmap <silent> <LEFT> :cprev<CR>

"Convert selected text to javascript string
"--------------------------------------------------------------------------------
function! s:ToJS(sep, first_line, last_line) 
    let i = a:first_line
    while i<a:last_line
      let l = getline(i)
      let l = substitute(l, a:sep, "\\\\".a:sep, "g")
      if i==a:last_line - 1
        call setline(i, a:sep . l . a:sep . ";" )
      else
        call setline(i, a:sep . l . a:sep . " + " )
      endif
      let i=i+1
    endwhile
endfunction

command!  -nargs=1 -range ToJs call s:ToJS(<q-args>, <line1>, <line2>)
