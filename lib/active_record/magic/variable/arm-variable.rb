load 'active_record/magic/variable/arm-options.rb'

### Global variable cache
module ActiveRecord
  module Magic
    module Variable
      
      include ActiveRecord::Magic::Log
      extend  ActiveRecord::Magic::Events::Extend
      
      @@cache ||= {}
      subscribe(ActiveRecord::Magic::Event::RELOAD) do
        @@cache = {}
      end
      subscribe(ActiveRecord::Magic::Event::RELOADED) do
        arm_log.debug('test')
      end

      def self.get(key, default=nil)
        @@cache[key] || default
      end
      def self.set(key, value)
        
      end
      def self.define(key, default)
        if @@cache.has_key?(key)
          @@cache[key]
        else
          @@cache[key] = default
        end
      end
      def self.defined?(key, default=nil)
        
      end
    end
  end
end