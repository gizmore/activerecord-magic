module ActiveRecord
  module Magic
    module Setting
      module Extend
        def has_setting(options)
          class_eval do |klass|
            
            # validate setting definition
            #Ricer3::SettingValidator.new(klass, options).validate!
      
            # register static for cleanup
            @db_settings = klass.define_class_variable(:@db_settings, {})
            @mem_settings = klass.define_class_variable(:@mem_settings, [])
      
            # static cache for this plugin      
            @mem_settings.push(options)
            
            # We have been here already
            return true if @mem_settings.length > 1
            
            ##########################
            ### Autodetected scope ###
            ##########################
            def setting(name)
              db_setting(name.to_sym)
            end
            
            def get_setting(name)
              setting(name).get_value
            end
      
            def display_setting(name)
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
            
            ############################
            ### Objects with setting ###
            ############################
            # def objects_with_setting(name, with_value, scope)
              # default = memory_setting_for_scope(name, scope)[:default]
              # matches = query_objects_with_setting(name, with_value, scope)
              # if (default == with_value)
                # all = get_all_objects_for_scope(scope)
                # matches = all - matches
              # end
              # matches
            # end
            # def get_all_objects_for_scope(scope)
              # Object.const_get(entity_type_for_scope(scope)).online.all
            # end
            # def query_objects_with_setting(name, with_value, scope)
              # entities = Ricer3::Setting.where(:plugin_id => self.id, :entity_type => entity_type_for_scope(scope), :value => with_value)
              # entities.collect { |e| e.entity }
            # end
            # def entity_type_for_scope(scope)
              # case scope
              # when :bot; "Ricer3::Bot";
              # when :server; "Ricer3::Server";
              # when :channel; "Ricer3::Channel";
              # when :user; "Ricer3::User";
              # end
            # end
            # def bots_with_setting(name, with_value)
              # objects_with_setting(name, with_value, :bot)
            # end
            # def channels_with_setting(name, with_value)
              # objects_with_setting(name, with_value, :channel)
            # end
            # def servers_with_setting(name, with_value)
              # objects_with_setting(name, with_value, :server)
            # end
            # def users_with_setting(name, with_value)
              # objects_with_setting(name, with_value, :user)
            # end
            
            #######################
            ### Cache and magic ###
            #######################
            def db_settings
              self.class.get_class_variable(:@db_settings)
            end
            
            def memory_settings
              self.class.get_class_variable(:@mem_settings)
            end
            
            def memory_setting(name)
              memory_settings.each do |options|
                return options if options[:name] == name
              end
              raise ActiveRecord::Magic::UnknownSetting.new(name)
            end
            
            def db_setting(name, create=true)
              if cached = db_settings[name]
                return cached if cached.persisted?
              elsif options = memory_setting(name)
                cached = ActiveRecord::Magic::Setting::Entry.find_or_initialize_by(name: name, entity: self)
                cached.init_param(options)
                db_settings[name] = cached
              end
              cached 
            end
      
          end
        end
        
      end
    end
  end
end
