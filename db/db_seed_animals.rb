require 'sqlite3'

db = SQLite3::Database.new("fruits.db")

db.execute <<-SQL
  CREATE TABLE IF NOT EXISTS animals (
    id INTEGER PRIMARY KEY,
    name TEXT NOT NULL,
    amount INTEGER NOT NULL
  );
SQL

db.execute("DELETE FROM animals")  # Rensa tabellen först

fruits = [
  ['Zebra',10], 
  ['Lejon',20], 
  ['Elefant',30], 
  ['Emu',40]
]

fruits.each do |animal|
  db.execute("INSERT INTO animals (name,amount) VALUES (?,?)", animal)
end

puts "Seed data inlagd."