![alt text](./mesa_logo.png)

# Mesa

Mesa is an object relational mapping tool that allows users to translate data from SQLite3 tables (<em>mesa</em>) to Ruby objects that can be manipulated by any Ruby web framework. In order to use `Mesa` methods on a model, its class
must inherit from `Mesa`.

For example:

```ruby
require 'mesa'

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
```

## How to Run the Example

### Requirements
`ruby -v 2.3.1p112` or later and `bundler version 1.12.5` or later

1. In the terminal, navigate to an empty project directory.

2. Run the command `git clone https://github.com/jaredjj3/Mesa`.

3. From the root directory, navigate to `./Mesa` and run the command `bundle install`.

4. After bundle installs the required gems, navigate to `./Mesa/test`

5. Run the command `ruby mesa_test.rb`

Mesa will setup the database, run some test queries, and print it to the terminal. You can edit the queries in `./Mesa/test/mesa_test.rb` and the database in `./Mesa/table.sql`. Alternatively, `mesa_test.rb` can be loaded in a Ruby REPL, such as pry, and the database can be updated using on of the queries given in the core features.

## Core Features

### CRUD
* `Mesa#create` - create method adds a new row to a table with the specified data
```ruby
Human.new(name: 'Jared Johnson').create
# adds a human named Jared Johnson to the database
```

* `Mesa#all` - read method that retrieves all the existing rows from the corresponding table in the database as hashes
```ruby
Table.all
# => Returns objects that map the data from each row
# {:id=>1, :name=>"Pine", :owner_id=>1}
# {:id=>2, :name=>"Oak", :owner_id=>2}
# {:id=>3, :name=>"Cherrywood", :owner_id=>3}
# {:id=>4, :name=>"Spruce", :owner_id=>3}
# {:id=>5, :name=>"Plastic", :owner_id=>nil}
```
* `Mesa::where` - read method that retrieves the existing rows from the corresponding table that meet the criteria
```ruby
Table.where(name: "Spruce")
# => Returns objects that map the data from each row
# that match the criteria
# {:id=>4, :name=>"Spruce", :owner_id=>3}
```

* `Mesa::update` - update method that updates an existing row in a table with the passed in id and data
```ruby
Human.update(id: 1, name: 'Jared Jemal Johnson')
# => Updates the name of the Human that has id == 1
```
* `Mesa#destroy` - allows the user to remove an existing row in a table
```ruby
Table.where(name: "Spruce").destroy
# => Removes the Spruce row from the "tables" Table in the database
```

### Associations
* `belongs_to` - defines getter/setter methods that make queries that satisfy the `:class_name`, `:foreign_key`, and `:primary_key` options

* `has_many` - defines getter/setter methods that make queries that
satisfy the `:class_name`, `:foreign_key`, and `:primary_key` options

* `has_one_through` - defines a getter/setter methods that make queries that
satisfy the `:through_name` and `:source_name` arguments.

```ruby
# In the Human class:
class Human < Mesa
  has_many :tables
end

# In the Table class:
class Table < Mesa
  belongs_to :owner,
    class_name: 'Human',
    foreign_key: :owner_id,
    primary_key: :id
end

Table.where(name: "Oak").first.owner
# {:id=>2, :fname=>"Anthony", :lname=>"Robinson", :house_id=>1}
```

## Technologies

`Mesa` is written using only Ruby. The `sqlite3 gem` was used to
establish a connection between the SQLite3 database and the library.

## Technical Implementation

`Mesa` extensively uses metaprogramming to accomplish the queries it
needs to make to return the desired output. Examples are `belongs_to_options`
and the `belongs_to_options` found [here](./lib/options).

A small consideration was made to improve the readability of the code.
Methods were monkey patched on Ruby's `String` class:
* `to_camelcase` - ExampleText
* `to_snakecase` - example_text
* `to_singular` - example_text
* `to_plural` - example_texts

## Future Releases

* Support for PostgresQL
* Sanitized input throughout
* Support for Rails
