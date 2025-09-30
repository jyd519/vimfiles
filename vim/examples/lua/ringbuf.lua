local ringbuf = vim.ringbuf(4)
ringbuf:push("a")
ringbuf:push("b")
ringbuf:push("c")
ringbuf:push("d")
ringbuf:push("e")    -- overrides "a"
print(ringbuf:pop()) -- returns "b"
print(ringbuf:pop()) -- returns "c"
-- Can be used as iterator. Pops remaining items:
for val in ringbuf do
  print(val)
end
