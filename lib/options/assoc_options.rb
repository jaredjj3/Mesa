require 'active_support/inflector'
require_relative 'active_support_helpers'

class AssocOptions
  attr_accessor :foreign_key, :class_name, :primary_key

  def model_class
    class_name.constantize
  end

  def table_name
    return "humans" if class_name == "Human"
    class_name.to_plural
  end
end
