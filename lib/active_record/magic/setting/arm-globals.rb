# Global variable cache that is reset on reload.
# The problem solved is multiple include of the same file (code reload safe),
# which might lead to @var ||= notations, which do not clear on a reload then.
module ActiveRecord
  module Magic
    class Global
      
      # arm_events
      
      @cache ||= {}

      # arm_subscribe(ActiveRecord::Magic::Event::RELOAD) do
        # @cache = {}
      # end
      
      def self.define(key, &default)
        has?(key) ? @cache[key] : set(key, yield)
      end

      def self.has?(key)
        @cache.has_key?(key)
      end
      
      def self.get(key, default=nil)
        @cache[key] || default
      end

      def self.set(key, value)
        @cache[key] = value
      end

    end
  end
end
