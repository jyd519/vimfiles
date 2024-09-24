local i=1
while  i < 5 do
  put(i)
  i = i + 1
end

for i = 1,5 do
  put(i)
end

for i = 1,10,2 do
  put(i)
end

for k,v in pairs({a=1,b=2}) do
  put(k, v)
end

local i = 0
repeat
  put(i)
  i = i + 1
until i  > 5

-- Breaking out:
local i = 1
while 1 do
  if  i > 5 then break end
  put(i)
  i = i + 1
end
