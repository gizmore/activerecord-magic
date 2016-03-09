class ActiveRecord::Magic::Base < ActiveRecord::Base

  def self.arm_connection
    @@arm_connection
  end

  def self.arm_connect(arm_config_database)
    @@arm_connection = ActiveRecord::Base.establish_connection(arm_config_database)
  end
  
end
