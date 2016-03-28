module ActiveRecord::Magic
  class Param::Datetime < Parameter
    
    # def default_options; super.merge({ min: 0, integer: false }); end
    
    def input_to_value(input)
      DateTime.parse(input)
    end

    def value_to_input(datetime)
      datetime.to_s
    end

  end
end
