module ActiveRecord
  module Magic
    class Pin
    
      attr_reader :value
    
      def initialize(input=nil, length=8)
        @value = filter(input) || random_pin(length)
      end
    
      def filter(input)
        input.gsub(/[^a-zA-Z0-9]/, '') rescue nil
      end
    
      def display
        @value.gsub(/(.{4})/, "\\1–").rtrim('–')
      end
    
      def matches?(input)
        @value == filter(input)
      end
    
    end
  end
end
