" hidden buffer
let N = 8

" method1
echo bufloaded(N) && win_findbuf(N)->empty()

" method2
echo bufexists(N) && getbufinfo(N)[0].hidden
