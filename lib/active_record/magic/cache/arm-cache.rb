load 'active_record/magic/cache/ar-patch.rb'
load 'active_record/magic/cache/arm-cache-slot.rb'
#
# arm_cache - ActiveRecord decorator
#
# @Usage
# class Foo < ActiveRecord::Base
#   arm_cache
#   arm_cached?; self.do_i_wanna_cache_this_record?; end
#   arm_named_cache :somefield  # adds Foo.by_somefield(somefield) assoc cache
#   arm_named_cache :some_guid, Proc.new{|values|"#{values[:field1]}SEPARATOR#{values[:field2]}"} # for composite assoc cache Foo.by_some_guid(:field1 => a, :field2 => b)
#
# (c) 2016, gizmore@wechall.net
#
module ActiveRecord
  module Magic
    module Cache
      module Extend

        # enable arm_cache for an ActiveRecord
        def arm_cache
          class_eval do |klass|
            
#            arm_log.debug{"ARM::Cache::arm_cache enabled for #{klass.short_name}."}

            # the classes cache
            def self.arm_get_cache; @@arm_cache[table_name] ||= {}; end
            def self.arm_get_caches; @@arm_caches[table_name] ||= {}; end
            
            @@arm_cache ||= {} # id
            @@arm_caches ||= {} # named
            @arm_cache_on = true # currently enabled?
            def arm_cached?; @arm_cached; end # row in cache?            
            def arm_cached=(bool); @arm_cached = bool; end

            
            # cache this self one row?
            def arm_cache?
              true # Override me :)
            end
            
            #######################
            ### Update triggers ###
            #######################
            
            # After a commit, update cache if necessary
            klass.after_save :arm_update_cache
            klass.after_destroy :arm_rollback_cache
            klass.after_rollback :arm_rollback_cache
            
            def arm_rollback_cache
              self.class.arm_cache_remove(self)
            end
            
            def arm_update_cache
              should_cache = arm_cache?
              if should_cache != arm_cached?
                should_cache ? self.class.arm_cache_add(self) : self.class.arm_cache_remove(self)
              end
            end
            
            ##############
            ### Delete ###
            ##############
            def delete
              result = super
              self.class.arm_cache_remove(self)
              result
            end

            def self.delete_all
              result = super
              arm_clear_cache
              result
            end
            
            ##############
            ### Static ###
            ##############

            # take record from cache
            def self.arm_cached(record)
              return record unless @arm_cache_on && record.arm_cache? # don't cache 
              return arm_get_cache[record.id] || arm_cache_add(record)   # cache(d)
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
              arm_get_cache.clear
              arm_get_caches.each{|name,slot|slot.clear}
            end
            
            # get by id
            def self.by_id(id)
              arm_get_cache[id] || find(id)
            end
            
            def self.cached_by_id(id)
              arm_get_cache[id]
            end
            
            # add a named cache slot
            def self.arm_named_cache(name, proc=nil)
              name = name.to_sym
              if proc.nil?
                proc = Proc.new{|values|values[name]}
                metaclass.instance_eval{define_method("by_#{name}"){|value| by(name,{:"#{name}" => value})}}
              else
                metaclass.instance_eval{define_method("by_#{name}"){|value| arm_get_caches[name].get(value) || where(value).first }}
              end
              arm_get_caches[name] = ActiveRecord::Magic::Cache::Slot.new(proc)
            end
            
            # get a named cache slot
            def self.arm_get_named_cache(name)
              arm_get_caches[name]
            end

            # by named cache
            def self.by(name, values={})
              cached_by(name, values) || where(values).first
            end
            
            def self.cached_by(name, values={})
              arm_get_caches[name.to_sym].get(values)
            end

            # add
            def self.arm_cache_add(record)
              record.arm_cached = true
              arm_get_cache[record.id] = record
              arm_get_caches.each{|name,slot|slot.add(record)}
              record
            end
            
            # remove
            def self.arm_cache_remove(record)
              record.arm_cached = false
              arm_get_cache.delete(record.id)
              arm_get_caches.each{|name,slot|slot.remove(record)}
              record
            end

          end
        end
      end
    end
  end
end

# make arm_cache available and turn AR class into a cachable
ActiveRecord::Base.extend ActiveRecord::Magic::Cache::Extend
