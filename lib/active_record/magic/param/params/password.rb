load File.expand_path("../string.rb", __FILE__)
module ActiveRecord::Magic
  class Param::Password < Param::String
    
    def default_options; { min: 4, max: 256 }; end

    def display_value; t(:censored); end
    
  end
end
