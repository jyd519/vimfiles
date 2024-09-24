Account = {}

function Account:new(balance)
  local t = setmetatable({}, { __index = Account })

  -- Your constructor stuff
  t.balance = (balance or 0)
  return t
end

function Account:withdraw(amount)
  print("Withdrawing "..amount.."...")
  self.balance = self.balance - amount
  self:report()
end

function Account:report()
  print("Your current balance is: "..self.balance)
end

a = Account:new(9000)
a:withdraw(200)    -- method call


-- Relational (binary)
-- __eq  __lt  __gt  __le  __ge
--   ==    <     >     <=    >=
-- ~=   -- Not equal, just like !=

-- Arithmetic (binary)
-- __add  __sub  __muv  __div  __mod  __pow
   -- +      -      *      /      %      ^

-- Arithmetic (unary)
-- __unm (unary minus)
   -- -
