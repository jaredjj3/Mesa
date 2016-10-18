require 'active_support/inflector'
require_relative 'options/assoc_options'
require_relative 'options/belongs_to_options'
require_relative 'options/has_many_options'

module Associatable
  def assoc_options
    @options ||= {}
  end

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

  def has_one_through(name, through_name, source_name)
    define_method(name) do
      through_options = self.class.assoc_options[through_name]
      source_options = through_options.model_class.assoc_options[source_name]

      query = <<-SQL
        SELECT
          #{source_options.table_name}.*
        FROM
          #{through_options.table_name}
        JOIN
          #{source_options.table_name}
          ON #{through_options.table_name}.#{source_options.foreign_key} =
           #{source_options.table_name}.#{source_options.primary_key}
        WHERE
          #{through_options.table_name}.#{through_options.primary_key} = ?
      SQL

      result = DBConnection.execute(query, send(through_options.primary_key))
      source_options.model_class.parse_all(result).first
    end
  end
end
