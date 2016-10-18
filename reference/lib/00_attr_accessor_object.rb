class AttrAccessorObject
  def self.my_attr_accessor(*names)
    names.each do |name|
      at_name = "@#{name}".to_sym
      getter_name = "#{name}".to_sym
      setter_name = "#{name}=".to_sym

      # getter
      define_method(getter_name) do
        instance_variable_get(at_name)
      end

      # setter
      define_method(setter_name) do |val = nil|
        instance_variable_set(at_name, val)
      end
    end
  end
end
