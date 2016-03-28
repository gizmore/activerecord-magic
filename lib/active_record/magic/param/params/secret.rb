load File.expand_path("../string.rb", __FILE__)
module ActiveRecord::Magic
  class Param::Secret < Param::String
    
    def display_value; t(:censored); end

  end
end
