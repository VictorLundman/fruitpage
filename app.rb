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

  redirect("/fruits")
end

get("/fruits/new") do
  slim(:"fruits/new")
end

def get_fruit(id)
  db = SQLite3::Database.new("db/fruits.db")
  db.results_as_hash = true

  fruits = db.execute("SELECT * FROM fruits WHERE id=?", id)
  if fruits.length != 1
    return nil
  end

  return fruits[0]
end

post("/fruits/:id/update") do
  id = params[:id].to_i
  
  @fruit = get_fruit(id)
  if !@fruit
    error(404)
  end

  db = SQLite3::Database.new("db/fruits.db")

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

get("/animals") do
  query = params[:q]

  db = SQLite3::Database.new("db/fruits.db")
  db.results_as_hash = true

  if query and !query.empty?
    @animals = db.execute("SELECT * FROM animals WHERE name LIKE ?", "%#{query}%")
  else
    @animals = db.execute("SELECT * FROM animals")
  end

  slim(:"animals/index")
end

post("/animals") do
  name = params[:name]
  amount = params[:amount].to_i

  db = SQLite3::Database.new("db/fruits.db")
  
  db.execute("INSERT INTO animals (name, amount) VALUES (?, ?)", [name, amount])

  redirect("/animals")
end

get("/animals/new") do
  slim(:"animals/new")
end

def get_animal(id)
  db = SQLite3::Database.new("db/fruits.db")
  db.results_as_hash = true

  animals = db.execute("SELECT * FROM animals WHERE id=?", id)
  if animals.length != 1
    return nil
  end

  return animals[0]
end

post("/animals/:id/update") do
  id = params[:id].to_i

  @animal = get_animal(id)
  if !@animal 
    error(404)
  end

  name = params[:name]
  amount = params[:amount].to_i

  db = SQLite3::Database.new("db/fruits.db")

  db.execute("UPDATE animals SET name=?, amount=? WHERE id=?", [name, amount, id])

  redirect("/animals")
end

get("/animals/:id/edit") do
  id = params[:id].to_i

  @animal = get_animal(id)
  if !@animal 
    error(404)
  end

  slim(:"animals/edit")
end

post("/animals/:id/delete") do
  id = params[:id].to_i

  @animal = get_animal(id)
  if !@animal 
    error(404)
  end

  db = SQLite3::Database.new("db/fruits.db")

  db.execute("DELETE FROM animals WHERE id=?", id)

  redirect("/animals")
end