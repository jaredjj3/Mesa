require_relative '../lib/mesa'

class Human < Mesa
  has_many :tables
  has_many :humans
  belongs_to :home,
    class_name: 'House',
    foreign_key: :house_id,
    primary_key: :id
end

class House < Mesa
  has_many :tables
end

class Table < Mesa
  belongs_to :owner,
    class_name: 'Human',
    foreign_key: :owner_id,
    primary_key: :id

  has_one_through :home, :owner, :home
end

system('clear')
puts "Table.all =>"
tables = Table.all
print tables.map{ |table| table.attributes }.join("\n")
puts
puts
puts "Table.find(1) =>"
puts Table.find(1).attributes.to_s
puts
puts "Table.where(name: 'Pine') =>"
puts Table.where(name: 'Pine').first.attributes
puts
puts "Table.find(2).owner =>"
puts Table.find(2).owner.attributes
puts
puts "Table.find(1).home"
puts Table.find(1).home.attributes
puts
puts "Table.new(name: 'Metal', owner_id: 2).save"
puts "Table.all"
Table.new(name: 'Metal', owner_id: 2).save
print Table.all.map{ |table| table.attributes }.join("\n")
puts
puts
puts "Table.all.last.destroy"
puts "Table.all"
Table.all.last.destroy
print Table.all.map{ |table| table.attributes }.join("\n")
puts
