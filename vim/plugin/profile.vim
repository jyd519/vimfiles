
fun! Profiling()
  if !exists('s:profiling_active')
    echom "Profiling activated"
    let s:profiling_active = 1
    if g:is_nvim 
      profile start nprofile.log
    else
      profile start profile.log
    endif
    profile func *
    profile file *
  else
    profile pause
    noautocmd qall!
  endif
endfun

