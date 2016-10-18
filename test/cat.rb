require_relative '../lib/mesa'

class Cat < Mesa

end

system('clear')
puts "Cat.all =>"
cats = Cat.all
print cats.map{ |cat| cat.attributes }.join("\n")
puts
puts
puts "Cat.find(1) =>"
print Cat.find(1).attributes.to_s + "\n"
puts
puts "Cat.where(name: 'Breakfast') =>"
print Cat.where(name: 'Breakfast').first.attributes.to_s + "\n"
