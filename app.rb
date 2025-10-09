require "sinatra"
require "slim"
require "sinatra/reloader"
require "sqlite3"

# fruits = [
#   {
#     "name" => "Banan",
#     "rating" => 5
#   },
#   {
#     "name" => "Äpple",
#     "rating" => 5
#   },
#   {
#     "name" => "Päron",
#     "rating" => 3
#   },
#   {
#     "name" => "Vindruva",
#     "rating" => 1
#   }
# ]

get("/") do
  slim(:home)
end

get("/about") do
  slim(:about)
end

# get("/fruits") do
#   @fruits = fruits
#   slim(:fruits)
# end

get("/fruits") do
  db = SQLite3::Database.new("db/fruits.db")
  db.results_as_hash = true

  query = params[:q]
  if query and !query.empty?
    @fruits = db.execute("SELECT * FROM fruits WHERE name LIKE ?", "%#{query}%")
  else
    @fruits = db.execute("SELECT * FROM fruits")
  end

  slim(:"fruits/index")
end

post("/fruits") do
  name = params[:name]
  amount = params[:amount]

  db = SQLite3::Database.new("db/fruits.db")

  db.execute("INSERT INTO fruits (name, amount) VALUES (?, ?)", [name, amount.to_i])

  p name
  p amount

  redirect("/fruits")
end

get("/fruits/new") do
  slim(:"fruits/new")
end

def get_fruit(id)
  db = SQLite3::Database.new("db/fruits.db")
  db.results_as_hash = true

  id = params[:id].to_i
  fruits = db.execute("SELECT * FROM fruits WHERE id=?", id)
  if fruits.length != 1
    return nil
  end

  return fruits[0]
end

# get("/fruits/:id") do
#   @fruit = get_fruit(params[:id].to_i)
#   if !@fruit
#     error(404)
#   end

#   slim(:"fruits/show")
# end

post("/fruits/:id/update") do
  id = params[:id].to_i
  
  @fruit = get_fruit(id)
  if !@fruit
    error(404)
  end

  db = SQLite3::Database.new("db/fruits.db")
  db.results_as_hash = true

  name = params[:name]
  amount = params[:amount].to_i

  db.execute("UPDATE fruits SET name=?, amount=? WHERE id=?", [name, amount, id])

  redirect("/fruits")
end

get("/fruits/:id/edit") do
  id = params[:id].to_i
  
  @fruit = get_fruit(id)
  if !@fruit
    error(404)
  end

  slim(:"fruits/edit")
end

post("/fruits/:id/delete") do
  id = params[:id].to_i

  @fruit = get_fruit(id)
  if !@fruit
    error(404)
  end

  db = SQLite3::Database.new("db/fruits.db")
  db.results_as_hash = true

  db.execute("DELETE FROM fruits WHERE id=?", id)

  redirect("/fruits")
end

# get("/fruits/:id") do
#   fruit_id = params[:id].to_i
#   @fruit = fruits[fruit_id]
#   slim(:fruit)
# end

get("/cat") do
  @cat = {
    "name" => "Katten",
    "age" => 5,
  }

  slim(:cat)
end