function! SecondBreakfast() dict
  return self.breakfast
endfunction


let meals = {"breakfast": "pancakes", "second_breakfast": function("SecondBreakfast"), "lunch": "pasta"}

echo meals.second_breakfast()
" returns "pancakes"

function! meals.second_lunch()
  return self.lunch
endfunction

echo meals.second_lunch()
" returns "pasta"
"
"
"
function! Lunch(item)
  return "I am having " . a:item . " for lunch"
endfunction

let lunch_items = ["sushi", "ramen", "sashimi"]

let day_meals = map(lunch_items, {index, item -> Lunch(item)})

for meal in day_meals
  echo meal
endfor"
