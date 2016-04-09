module ActiveRecord
  module Magic
    module Setting
      class Entry < ActiveRecord::Base

        self.table_name = 'arm_settings'
        
        arm_cache
        
        belongs_to :entity, :polymorphic => true
        
        arm_install do |migration|
          migration.create_table(table_name) do |t|
            t.integer :entity_id,   :null => false
            t.integer :entity_type, :null => false
            t.string  :name,        :null => false, :limit => 32,  :charset => :ascii, :collation => :ascii_bin
            t.string  :value,       :null => false
            t.timestamps :null => false
          end
        end
        
        def init_param(options)
          @param = ActiveRecord::Magic::Parameter.from_setting_options(options)
          self.value ||= @param.get_value
          @param.set_value(@param.input_to_value(self.value)) 
        end
        
        def get_value
          @param.get_value
        end

        def save_value(value)
          @param.set_value(value)
          self.value = @param.db_value
          self.save!
          get_value
        end
        
        def display_value
          @param.display_value
        end
        
      end
    end
  end
end
