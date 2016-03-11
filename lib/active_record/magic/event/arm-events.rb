module ActiveRecord
  module Magic
    module Event
      INIT ||= 'ARM.INIT' # application has installed base system.
      INSTALLED ||= 'ARM.INSTALLED' # application has installed updates.
      CONFIGURE ||= 'ARM.CONFIGURE' # application should configure system.
      RELOAD ||= 'ARM.RELOAD' # application is about to reload.
      RELOADED ||= 'ARM.RELOADED' # application has been reloaded.
    end
  end
end
      
