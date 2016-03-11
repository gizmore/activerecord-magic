class Object
  def metaclass
    class << self; self; end
  end
  def obj_id
    "#{self.class.short_name}@#{object_id}"
  end
end

class Module
  def short_name
    name.rsubstr_from('::', name)
  end
end

class Class
  def short_name
    name.rsubstr_from('::', name)
  end
end

class Proc
  def short_location
    "#{source_location.join(' Line ').rsubstr_from('/')}"
  end
end