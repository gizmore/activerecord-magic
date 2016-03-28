class ActiveRecord::Magic::UnknownOption < ActiveRecord::Magic::InvalidCode
  def initialize(valid, given, key)
    @valid = valid
    @given = given
    @key = key
  end
end

class ActiveRecord::Magic::InvalidOption < ActiveRecord::Magic::InvalidCode
  def initialize(valid, given, key)
    @valid = valid
    @given = given
    @key = key
  end
  
  def to_s
    "#{@key} has an invalid or non matching class given: #{@given} - #{@given.class}. Example would be: #{@valid}"
  end
end

class ActiveRecord::Magic::UnknownSetting < ActiveRecord::Magic::InvalidCode
  def initialize(name)
    @name = name
  end
end
