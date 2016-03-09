module ActiveRecord
  module Magic
    module Cache
      class Slot
        
        def initialize(proc)
          @proc = proc
          clear
        end
        
        def clear
          @cache = {}
          self
        end
        
        def key(values)
          @proc.call(values)
        end
        
        def add(record)
          @cache[key(record.attributes)] = record
        end
        
        def get(values)
          @cache[key(values)]
        end
        
        def remove(record)
          @cache.delete(key(record.attributes))
        end

      end
    end
  end
end
