require_relative 'db_connection'
require 'active_support/inflector'
require 'byebug'

# NB: the attr_accessor we wrote in phase 0 is NOT used in the rest
# of this project. It was only a warm up.

class SQLObject

  def self.columns
    return @result if @result

    query = <<-SQL
      SELECT
        *
      FROM
        #{self.table_name}
    SQL

    @result = DBConnection.execute2(query).first.map(&:to_sym)
  end

  def self.finalize!
    self.columns.each do |col_name|
      getter_name = "#{col_name}".to_sym
      setter_name = "#{col_name}=".to_sym

      # getter
      define_method(getter_name) do
        # instance_variable_get(at_name)
        attributes[getter_name]
      end

      # setter
      define_method(setter_name) do |val = nil|
        # instance_variable_set(at_name, val)
        attributes[getter_name] = val
      end
    end
  end

  def self.table_name=(table_name)
    @table_name = table_name
  end

  def self.table_name
    return "humans" if self.to_s == "Human"
    self.to_s.tableize
  end

  def self.all
    query = <<-SQL
      SELECT
        #{self.table_name}.*
      FROM
        #{self.table_name}
    SQL

    results = DBConnection.execute(query)
    self.parse_all(results)
  end

  def self.parse_all(results)
    results.map { |params| self.new(params) }
  end

  def self.find(id)
    query = <<-SQL
      SELECT
        *
      FROM
        #{self.table_name}
      WHERE
        id = ?
      LIMIT
        1
    SQL

    result = DBConnection.execute(query, id)
    self.parse_all(result).first
  end

  def initialize(params = {})
    params.each do |attr_name, attr_val|
      sym_attr_name = attr_name.to_sym
      str_attr_name = attr_name.to_s

      unless self.class.columns.include?(sym_attr_name)
        raise "unknown attribute '#{attr_name}'"
      end

      send("#{str_attr_name}=", attr_val)
    end
  end

  def attributes
    @attributes ||= {}
  end

  def attribute_values
    self.class.columns.map{ |column| send(column.to_s) }
  end

  def insert
    col_names = "(#{self.class.columns.join(", ")})"
    question_marks = "(#{(["?"] * self.class.columns.length).join(", ")})"

    query = <<-SQL
      INSERT INTO
        #{self.class.table_name} #{col_names}
      VALUES
        #{question_marks}
    SQL

    DBConnection.execute(query, *attribute_values)
    attributes[:id] = DBConnection.last_insert_row_id
  end

  def update
    set_str = self.class.columns.map { |column| "#{column.to_s} = :#{column}" }.join(", ")

    query = <<-SQL
      UPDATE
        #{self.class.table_name}
      SET
        #{set_str}
      WHERE
        id = ?
    SQL

    DBConnection.execute(query, *attribute_values, attributes[:id])
  end

  def save
    id.nil? ? insert : update
  end
end
