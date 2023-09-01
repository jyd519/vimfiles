" Vim syntax file
if exists("b:current_syntax")
  finish
endif

syn keyword log_version app_version unlock_desktop lock_desktop
" syn region log_string   start=/'/ end=/'/ end=/$/ skip=/\\./
syn region log_string   start=/"/ end=/"/ skip=/\\./
" syn match log_number  '0x[0-9a-fA-F]*\|\[<[0-9a-f]\+>\]\|\<\d[0-9a-fA-F]*'

syn match   log_date '\(Jan\|Feb\|Mar\|Apr\|May\|Jun\|Jul\|Aug\|Sep\|Oct\|Nov\|Dec\) [ 0-9]\d *'
syn match   log_date '\d\{4}-\d\d-\d\d'
syn match   log_time '\d\d:\d\d:\d\d\s*'
syn match   log_time '\c\d\d:\d\d:\d\d\(\.\d\+\)\=\([+-]\d\d:\d\d\|Z\)'

syn match   log_datetime '\d\{4}-\d\d-\d\dT' nextgroup=log_time
syntax region log_datetime matchgroup=log_time_bracket start=/^\[/ end=/\]/ contains=log_datetime

syntax cluster log_times contains=log_date,log_time,log_datetime

syn match log_error   '\c.*\<\(FATAL\|ERROR\|ERRORS\|FAIL\|FAILED\|FAILURE\).*$' contains=@log_times
syn match log_warning   '\c.*\<\(WARNING\|DELETE\|DELETING\|DELETED\|RETRY\|RETRYING\).*$' contains=@log_times

hi def link log_string    String
" hi def link log_number    Number
hi def link log_date    Constant
hi def link log_datetime    Constant
hi def link log_time    Type
hi def link log_error     ErrorMsg
hi def link log_warning   WarningMsg
hi def link log_version   keyword 

let b:current_syntax = "log"
