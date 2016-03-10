module ActiveRecord; module Magic; end; end

class ActiveRecord::Magic::Exception < StandardError
end

class ActiveRecord::Magic::InvalidConfig < ActiveRecord::Magic::Exception
end

class ActiveRecord::Magic::MissingConfiguration < ActiveRecord::Magic::Exception
end 

class ActiveRecord::Magic::InvalidCode < Exception
  
  def initialize(message)
    byebug
  end
  
end

