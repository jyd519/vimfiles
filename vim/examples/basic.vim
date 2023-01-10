"-------------------- 
let mylist = [1, 2, ['a', 'b']]
echo mylist[0]
" 1
echo mylist[2][0]
" a
echo mylist[-2]
" 2
" echo mylist[999]
" E684: list index out of range: 999
echo get(mylist, 999, "THERE IS NO 1000th ELEMENT")
" THERE IS NO 1000th ELEMENT

"-------------------- 
let mydict = {'blue': "#0000ff", 'foo': {999: "baz"}}
echo mydict["blue"]
" #0000ff
echo mydict.foo
" {999: "baz"}
echo mydict.foo.999
" baz
let mydict.blue = "BLUE"
echo mydict.blue
" BLUE


"-------------------- 
" There is no Boolean type. Numeric value 0 is treated as falsy, while anything else is truthy.
" Strings are converted to integers before checking truthiness.


"-------------------- 
echo 1 . "foo"
" 1foo
echo 1 + "1"
" 2


"-------------------- 
" <string> == <string>: String equals.
" <string> != <string>: String does not equal.
" <string> =~ <pattern>: String matches pattern.
" <string> !~ <pattern>: String doesn’t match pattern.
" <operator>#: Additionally match case.
" <operator>?: Additionally don’t match case.


"-------------------- 
" if <expression>
" 	...
" elseif <expression>
" 	...
" else
" 	...
" endif


" for <var> in <list>
" 	continue
" 	break
" endfor
"
" while <expression>
" endwhile

for [var1, var2] in [[1, 2], [3, 4]]
	" on 1st loop, var1 = 1 and var2 = 2
	" on 2nd loop, var1 = 3 and var2 = 4
endfor


"-------------------- 
" try
" 	...
" catch <pattern (optional)>
" 	" HIGHLY recommended to catch specific error.
" finally
" 	...
" endtry


"-------------------- 
function! g:Foobar(arg1, arg2, ...)
	let first_argument = a:arg1
	let index = 1
	let variable_arg_1 = a:{index} " same as a:1
	return variable_arg_1
endfunction

function! RangeSize() range
    echo a:lastline - a:firstline
endfunction

"-------------------- 
let Myfunc = function("strlen")
echo Myfunc('foobar') 
" > 6 

lua << EOF
-- your lua code here
print(vim.loop.os_uname().sysname)
print(vim.loop.os_gethostname())
EOF

" http://www.ibm.com/developerworks/linux/library/l-vim-script-1/index.html
" https://developer.ibm.com/tutorials/l-vim-script-4/
" http://andrewscala.com/vimscript/
