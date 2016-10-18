require_relative '02_searchable'
require 'active_support/inflector'

# helpers
class String
  def to_camelcase
    self.camelcase
  end

  def to_snakecase
    self.underscore
  end

  def to_singular
    self.singularize
  end

  def to_plural
    self.tableize
  end
end

# Phase IIIa
class AssocOptions
  attr_accessor(
    :foreign_key,
    :class_name,
    :primary_key
  )

  def model_class
    class_name.constantize
  end

  def table_name
    return "humans" if class_name == "Human"
    class_name.to_plural
  end
end

class BelongsToOptions < AssocOptions
  def initialize(name, options = {})
    @name = name

    default_options = {
      foreign_key: "#{name.to_s.to_snakecase}_id".to_sym,
      class_name: name.to_s.to_camelcase.to_singular,
      primary_key: :id
    }

    options = default_options.merge(options)

    options.each do |option, value|
      setter_name = "#{option.to_s}=".to_sym

      send(setter_name, value)
    end
  end
end

class HasManyOptions < AssocOptions
  def initialize(name, self_class_name, options = {})
    @name = name
    @self_class_name = self_class_name

    default_options = {
      foreign_key: "#{self_class_name.to_s.to_snakecase}_id".to_sym,
      class_name: name.to_s.to_camelcase.to_singular,
      primary_key: :id
    }

    options = default_options.merge(options)

    options.each do |option, value|
      setter_name = "#{option.to_s}=".to_sym

      send(setter_name, value)
    end
  end
end

module Associatable
  # Phase IIIb
  def belongs_to(name, options = {})
    options = BelongsToOptions.new(name, options)
    assoc_options[name] = options.dup

    define_method(name) do
      foreign_key = send(options.foreign_key)
      primary_key = options.primary_key
      options.model_class.where(primary_key => foreign_key).first
    end
  end

  def has_many(name, options = {})
    options = HasManyOptions.new(name, self.name.to_snakecase, options)

    define_method(name) do
      primary_key = send(options.primary_key)
      foreign_key = options.foreign_key
      options.model_class.where(foreign_key => primary_key)
    end
  end

  def assoc_options
    # Wait to implement this in Phase IVa. Modify `belongs_to`, too.
    @options ||= {}
  end
end

class SQLObject
  # Mixin Associatable here...
  extend Associatable
end
