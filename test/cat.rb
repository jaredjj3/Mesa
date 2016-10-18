require_relative '../lib/mesa'

class Cat < Mesa

end

puts "Cat.all"
p Cat.all
puts
puts "Cat.find(1)"
puts Cat.find(1)
puts
puts "Cat.where(name: 'Breakfast')"
puts Cat.where(name: 'Breakfast')
