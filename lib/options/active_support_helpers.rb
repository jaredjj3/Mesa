require 'active_support/inflector'

class String
  def to_camelcase
    self.to_s.camelcase
  end

  def to_snakecase
    self.to_s.underscore
  end

  def to_singular
    self.to_s.singularize
  end

  def to_plural
    self.to_s.tableize
  end
end
