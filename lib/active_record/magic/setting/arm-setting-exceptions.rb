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
end

class ActiveRecord::Magic::UnknownSetting < ActiveRecord::Magic::InvalidCode
  def initialize(name)
    @name = name
  end
end
