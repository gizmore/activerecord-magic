module ActiveRecord
  module Magic
    module Event
      INIT ||= 'arm.init' # application has installed base system.
      INSTALLED ||= 'arm.installed' # application has installed updates.
      CONFIGURE ||= 'arm.configure' # application should configure system.
      RELOAD ||= 'arm.reload' # application is about to reload.
      RELOADED ||= 'arm.reloaded' # application has been reloaded.
    end
  end
end
      
