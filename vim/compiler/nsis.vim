" Vim compiler file

if exists("current_compiler")
  finish
endif
let current_compiler = "nsis"

if exists(":CompilerSet") != 2		" older Vim always used :setlocal
  command -nargs=* CompilerSet setlocal <args>
endif

" default errorformat
CompilerSet errorformat&

CompilerSet makeprg=D:\tools\setup\NSIS\makensis\ /v2\ $*\ %
