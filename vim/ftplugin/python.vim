let b:surround_{char2nr('-')} = "\"\"\" \r \"\"\""
let b:surround_{char2nr('d')} = "\"\"\" \r \"\"\""

if g:is_nvim
  lua  <<END
require("nvim-surround").buffer_setup(
    {
        surrounds = {
            ["-"] = {
                add = function()
                    return {{'"""'}, {'"""'}}
                end
            },
            ["d"] = {
                add = function()
                    return {{'"""'}, {'"""'}}
                end
            }
        }
    }
)
END
endif

function! VirtualEnvSitePackagesFolder()
  if $VIRTUAL_ENV == ""
    return ""
  endif

  " Try a few candidate Pythons to see which this virtualenv uses.
  for python in ["python3.11", "python3.12", "python3.8", "python3.9"]
    let candidate = $VIRTUAL_ENV . "/lib/" . python
    if isdirectory(candidate)
      return candidate . "/site-packages/"
    endif
  endfor

  return ""
endfunction

cnoremap %v <C-R>=VirtualEnvSitePackagesFolder()<cr>

" pyflyby
function! s:PyPostSave()
  if has("win32")
    echom "pyflyby is not supported on Windows :("
    return
  endif
  execute "silent !tidy-imports --black --quiet --replace-star-imports --action REPLACE " . bufname("%")
  execute "silent !isort " . bufname("%")
  execute "e"
endfunction
noremap <buffer> <leader>i :call <SID>PyPostSave()<cr>
command! PyImport call <SID>PyPostSave()

" dap
command! -buffer DebugTest lua require("dap-python").test_method()
