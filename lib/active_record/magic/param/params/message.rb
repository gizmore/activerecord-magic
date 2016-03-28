load File.expand_path("../string.rb", __FILE__)
module ActiveRecord::Magic
  class Param::Message < Param::String
    
    def default_values; { min: 0, max: nil, default: '' }; end

    def default_eater; true; end
    
  end
end
