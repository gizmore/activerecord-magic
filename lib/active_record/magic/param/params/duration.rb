load File.expand_path("../float.rb", __FILE__)
module ActiveRecord::Magic
  class Param::Duration < Param::Float
    
    def default_options; super.merge({ min: 0, integer: false }); end
    
    def input_to_value(input)
      duration = human_to_seconds(input)
      options[:integer] ? duration.to_i : duration.to_f
    end

    def value_to_input(value)
      human_duration(value) rescue nil
    end

  end
end
