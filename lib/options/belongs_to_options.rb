require 'active_support/inflector'
require_relative 'active_support_helpers'
require_relative 'assoc_options'


class BelongsToOptions < AssocOptions
  def initialize(name, options = {})
    @name = name

    default_options = {
      foreign_key: "#{ name.to_s.to_snakecase }_id".to_sym,
      class_name: name.to_s.to_camelcase.to_singular,
      primary_key: :id
    }

    options = default_options.merge(options)

    options.each do |option, value|
      setter_name = "#{ option.to_s }=".to_sym
      send(setter_name, value)
    end
  end
end
