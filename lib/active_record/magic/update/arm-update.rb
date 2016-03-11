require "active_record"

load "active_record/magic/update/arm-records.rb"
load "active_record/magic/update/arm-install.rb"
load "active_record/magic/update/arm-update-exceptions.rb"
load "active_record/magic/update/arm-update-step.rb"
load "active_record/magic/update/arm-update-steps.rb"
load "active_record/magic/update/arm-update-chain.rb"

module ActiveRecord
  module Magic
    module Update

      def self.install
        arm_log.debug{"ActiveRecord::Magic::Update.install()"}
        ActiveRecord::Magic::Record.arm_record_install_v1
        true
      end

      def self.run
        arm_log.debug{"ActiveRecord::Magic::Update.run()"}
        total = 0
        chain = ActiveRecord::Magic::Global.get('arm_install_chain')
        chain.load_installed_versions
        while chain.runs_left?
          chain.run
          throw ActiveRecord::Magic::MissingDependency.new(chain) if total == chain.total
          total = chain.total
        end
        true
      end

    end    
  end
end
