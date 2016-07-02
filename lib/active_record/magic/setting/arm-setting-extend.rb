module ActiveRecord
  module Magic
    module Setting
      module Include
        
        def setting(name)
          db_setting(name.to_sym)
        end
        
        def get_setting(name)
          setting(name).get_value
        end
  
        def show_setting(name)
          setting(name).display_value
        end
    
        def save_setting(name, value)
          setting(name).save_value(value)
        end
        
        def delete_setting(name)
          db_setting(name, false).delete!
        end
        
        def increase_setting(name, by=1)
          save_setting(name, get_setting(name) + by)
        end

        #######################
        ### Cache and magic ###
        #######################
        def db_settings
          self.define_class_variable(:@db_settings, {})
        end
        
        def memory_settings
          self.define_class_variable(:@mem_settings, [])
        end
        
        def memory_setting(name)
          memory_settings.each do |options|
            return options if options[:name] == name
          end
          nil
          #raise ActiveRecord::Magic::UnknownSetting.new(name)
        end
        
        def db_setting(name, create=true)
          if cached = db_settings[name]
            #return cached if cached.persisted?
          elsif options = memory_setting(name)
            cached = ActiveRecord::Magic::Setting::Entry.find_or_initialize_by(name: name, entity: self)
            cached.init_param(options)
            db_settings[name] = cached
          end
          cached 
        end
      end

      module Extend
        def arm_setting(options)
          class_eval do |klass|
            # static cache for this plugin      
            @mem_settings = klass.define_class_variable(:@mem_settings, [])
            @mem_settings.push(options)
          end
        end
      end

    end
  end
end
