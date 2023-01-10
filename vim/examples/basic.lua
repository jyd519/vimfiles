---@diagnostic disable: lowercase-global
--
--[[ 
This is all commented out.
None of it is going to run!
]]


-- We can create long strings and maintain white space
local longString = [[
I am a very very long
string that goes on for
ever]]
print(longString, "\n")


-- Generate random number between 0 and 1
print("math.random() : ", math.random(), "\n")

-- Generate random number between 1 and 10
print("math.random(10) : ", math.random(10), "\n")

-- Generate random number between 1 and 100
print("math.random(1,100) : ", math.random(1,100), "\n")

-- Print float to 10 decimals
print(string.format("Pi = %.10f", math.pi))

print(type("Candied Apples")) -- Output: string
print(type(45)) -- Output: number

local numOfSlices = 8
print("This pizza has " ..  numOfSlices .. " slices!")
print("1" + 1)
-- Output: 2
print(tonumber("2") + 1)
-- Output: 3



-- ---------- CONDITIONALS ----------
-- Relational Operators : > < >= <= == ~=
-- Logical Operators : and or not

local age = 13
if age < 16 then
    print("You can go to school", "\n")
elseif (age >= 16) and (age < 18) then
    print("You can drive", "\n")
else
    print("You can vote", "\n")
end

-- This is similar to the ternary operator
local canVote = age > 18 and true or false  -- age > 18 ? true : false
print(canVote)  -- false

print(6 ~= 5)          -- Evaluates to: true 
print(true and 5 == 5)  -- Evaluates to true 
print(false or 5 == 5)  -- Evaluates to: true 
print(not ("Hello" == "Hello"))  -- Evaluates to: false


-- ---------- LOOPING ----------
i = 1
while (i <= 10) do
  print(i)
  i = i + 1

  -- break throws you out of a loop
  -- continue doesn't exist with Lua
  if i == 8 then break end
end
print("\n")

-- Repeat will cycle through the loop at least once
repeat
  print("Enter your guess : ")

  -- Gets input from the user
  guess = io.read()

  -- Either surround the number with quotes, or convert the string into
  -- a number
until tonumber(guess) == 15

-- Value to start with, value to stop at, increment each loop
for i = 1, 10, 1 do
  print(i)
end


-- Create a table which is a list of items like an array
months = {"January", "February", "March", "April", "May",
"June", "July", "August", "September", "October", "November",
"December"}

-- Cycle through table where k is the key and v the value of each item
for k, v in pairs(months) do
  print(v, " ")
end

-- ---------- FUNCTIONS ----------
local function double(x)
  return 2 * x
end
print(double(2)) -- Prints: 4


function splitStr(theString)

  local stringTable = {}
  local i = 1

  -- Cycle through the String and store anything except for spaces
  -- in the table
  for str in string.gmatch(theString, "[^%s]+") do
    stringTable[i] = str
    i = i + 1
  end

  -- Return multiple values
  return stringTable, i
end

-- Variadic Function recieve unknown number of parameters
function getSumMore(...)
  local sum = 0

  for k, v in pairs{...} do
    sum = sum + v
  end
  return sum
end

print("Sum : ", getSumMore(1,2,3,4,5,6), "\n")

-- Saving an anonymous function to a variable
doubleIt = function(x) return x * 2 end
print(doubleIt(4))

-- A Closure is a function that can access local variables of an enclosing
-- function
function outerFunc()
  local i = 0
  return function()
    i = i + 1
    return i
  end
end

-- When you include an inner function in a function that inner function
-- will remember changes made on variables in the inner function
getI = outerFunc()
print(getI())
print(getI())
-- ---------- FILE I/O ----------
-- Different ways to work with files
-- r: Read only (default)
-- w: Overwrite or create a new file
-- a: Append or create a new file
-- r+: Read & write existing file
-- w+: Overwrite read or create a file
-- a+: Append read or create file

-- Create new file for reading and writing
file = io.open("test.lua", "w+")

-- Write text to the file
file:write("Random string of text\n")
file:write("Some more text\n")

-- Move back to the beginning of the file
file:seek("set", 0)

-- Read from the file
print(file:read("*a"))

-- Close the file
file:close()

-- Open file for appending and reading
file = io.open("test.lua", "a+")

file:write("Even more text\n")
file:seek("set", 0)
print(file:read("*a"))
file:close()


