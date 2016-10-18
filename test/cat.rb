require_relative '../lib/mesa'

class Human < Mesa
  has_many :cats
  has_many :humans
  belongs_to :home,
    class_name: 'House',
    foreign_key: :house_id,
    primary_key: :id
end

class House < Mesa
  has_many :cats
end

class Cat < Mesa
  belongs_to :owner,
    class_name: 'Human',
    foreign_key: :owner_id,
    primary_key: :id

  has_one_through :home, :owner, :home
end

system('clear')
puts "Cat.all =>"
cats = Cat.all
print cats.map{ |cat| cat.attributes }.join("\n")
puts
puts
puts "Cat.find(1) =>"
puts Cat.find(1).attributes.to_s
puts
puts "Cat.where(name: 'Breakfast') =>"
puts Cat.where(name: 'Breakfast').first.attributes
puts
puts "Cat.find(2).owner =>"
puts Cat.find(2).attributes
puts
puts "Cat.find(1).home"
puts Cat.find(1).home.attributes
puts
puts "Cat.new(name: 'Nacho', owner_id: 2).save"
puts "Cat.all"
puts Cat.new(name: 'Nacho', owner_id: 2).save
print Cat.all.map{ |cat| cat.attributes }.join("\n")
puts
puts "Cat.all.last.destroy"
puts "Cat.all"
Cat.all.last.destroy
print Cat.all.map{ |cat| cat.attributes }.join("\n")
puts
