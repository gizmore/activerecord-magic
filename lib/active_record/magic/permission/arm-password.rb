module ActiveRecord
  module Magic
    class Password
    
      def initialize(string=nil)
        @length = 0
        @empty = string.nil? || string.empty?
        begin
          unless @empty
            @hash = BCrypt::Password.new(string)
            @length = 32
          end
        rescue
          @hash = BCrypt::Password.create(string)
          @length = string.length
        end
      end
      
      def length
        @length
      end
      
      def to_s
        @hash.to_s
      end
      
      def matches?(password)
        @empty ? false : @hash.is_password?(password)
      end
    
    end
  end
end
