load 'active_record/magic/cache/ar-patch.rb'
load 'active_record/magic/cache/arm-cache-slot.rb'

module ActiveRecord
  module Magic
    module Cache
      module Extend

        # enable arm_cache
        def arm_cache
          class_eval do |klass|

            arm_log.debug{"ARM::Cache::arm_cache enabled for #{klass.short_name}."}

            # the classes cache
            @arm_cache = {} # id
            @arm_caches = {} # named
            @arm_cache_on = true # currently enabled?
            def self.arm_get_cache; @arm_cache; end
            
            # cache this row?
            def arm_cache?
              true
            end

            # take record from cache
            def self.arm_cached(record)
              return record unless @arm_cache_on && record.arm_cache?
              return @arm_cache[record.id] || arm_cache_add(record)
            end

            # uncached request
            def self.arm_uncached(&block)
              @arm_cache_on = false
              result = yield(self)
              @arm_cache_on = true
              result
            end
            
            # clear cache
            def self.arm_clear_cache
              @arm_cache = {}
              @arm_caches.each{|name,slot|slot.clear}
            end
            
            # get by id
            def self.by_id(id)
              @arm_cache[id] || find(id)
            end
            
            def self.cached_by_id(id)
              @arm_cache[id]
            end
            
            # add a named cache slot
            def self.arm_named_cache(name, proc=nil)
              if proc.nil?
                proc = Proc.new{|values|values[name]}
                metaclass.instance_eval{define_method("by_#{name}"){|value| by(name,{name:value})}}
              else
                metaclass.instance_eval{define_method("by_#{name}"){|value| @arm_caches[name].get(value) || where(value).first }}
              end
              @arm_caches[name] = ActiveRecord::Magic::Cache::Slot.new(proc)
            end
            
            # get a named cache slot
            def self.arm_get_named_cache(name)
              @arm_caches[name]
            end

            # by named cache
            def self.by(name, values={})
              cached_by(name, values) || where(values).first
            end
            
            def self.cached_by(name, values={})
              @arm_caches[name].get(values)
            end

            # add
            def self.arm_cache_add(record)
              @arm_cache[record.id] = record
              @arm_caches.each{|name,slot|slot.add(record)}
              record
            end
            
            # remove
            def self.arm_cache_remove(record)
              @arm_cache.delete(record.id)
              @arm_caches.each{|name,slot|slot.remove(record)}
              record
            end

          end
        end
      end
    end
  end
end

# make arm_cache available to turn class into cachable
ActiveRecord::Base.extend ActiveRecord::Magic::Cache::Extend
