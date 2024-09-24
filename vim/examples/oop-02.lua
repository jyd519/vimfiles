-- ---------- OBJECT ORIENTED PROGRAMMING ----------
-- Lua is not an OOP language and it doesn't allow you to define classes
-- but you can fake it using tables and metatables

-- Define the defaults for our table
Animal = {height = 0, weight = 0, name = "No Name", sound = "No Sound"}

-- Used to initialize Animal objects
function Animal:new (height, weight, name, sound)

  setmetatable({}, Animal)

  -- Self is a reference to values for this Animal
  self.height = height
  self.weight = weight
  self.name = name
  self.sound = sound

  return self
end

-- Outputs a string that describes the Animal
function Animal:toString()

  animalStr = string.format("%s weighs %.1f lbs, is %.1f in tall and says %s", self.name, self.weight, self.height, self.sound)

  return animalStr
end

-- Create an Animal
spot = Animal:new(10, 15, "Spot", "Roof")

-- Get variable values
print(spot.weight)

-- Call a function in Animal
print(spot:toString())

-- ---------- INHERITANCE ----------
-- Extends the properties and functions in another object

Cat = Animal:new()

function Cat:new (height, weight, name, sound, favFood)
  setmetatable({}, Cat)

  -- Self is a reference to values for this Animal
  self.height = height
  self.weight = weight
  self.name = name
  self.sound = sound
  self.favFood = favFood

  return self
end

-- Overide an Animal function
function Cat:toString()

  catStr = string.format("%s weighs %.1f lbs, is %.1f in tall, says %s and loves %s", self.name, self.weight, self.height, self.sound, self.favFood)

  return catStr
end

-- Create a Cat
fluffy = Cat:new(10, 15, "Fluffy", "Meow", "Tuna")

print(fluffy:toString())
