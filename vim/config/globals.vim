let g:is_nvim = has('nvim')
let g:is_vim8 = v:version >= 800 ? 1 : 0

if !exists("g:enabled_plugins")
  let g:enabled_plugins = {}
endif

" Disable Builtin Plugins
let g:loaded_gzip = 1
let g:loaded_zip = 1
let g:loaded_zipPlugin = 1
let g:loaded_tar = 1
let g:loaded_tarPlugin = 1
let g:loaded_getscript = 1
let g:loaded_getscriptPlugin = 1
let g:loaded_vimball = 1
let g:loaded_vimballPlugin = 1
" let g:loaded_2html_plugin = 1
let g:loaded_matchit = 1
let g:loaded_matchparen = 1
let g:loaded_logiPat = 1
let g:loaded_rrhelper = 1

" use netrw?
if get(g:enabled_plugins, "netrw", 0)
  let g:netrw_banner = 0
  let g:netrw_liststyle = 3
  let g:netrw_browse_split = 0
  let g:netrw_altv = 1
  let g:netrw_winsize = 25
else
  let g:loaded_netrw = 1
  let g:loaded_netrwPlugin = 1
  let g:loaded_netrwSettings = 1
  let g:loaded_netrwFileHandlers = 1
endif

" Enable syntax highlight for embeded lua & python code
let g:vimsyn_embed = 'lP'

let g:mapleader = ","
let g:maplocalleader = ","

" surround_no_insert_mappings
let g:surround_no_insert_mappings=1

if $HOME == ""
  $HOME = expand("~")
endif

if g:is_nvim
  lua <<END
local function prequire(m)
  local ok, err = pcall(require, m)
  if not ok then return nil, err end
  return err
end
_G.prequire = prequire
function _G.put(...)
  local objects = vim.tbl_map(vim.inspect, {...})
  print(unpack(objects))
end
_G.dump = _G.put
END
endif

" startify
let g:startify_change_to_dir = 0
let g:startify_change_to_vcs_root = 1

