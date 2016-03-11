module ActiveRecord
  module Magic
    module Update
      module Extend

        def arm_install(dependencies={}, &block)
          class_eval do |klass|
            chain = ActiveRecord::Magic::Global.define('arm_install_chain') { ActiveRecord::Magic::Update::Chain.new }
            chain.add_step(klass.name, dependencies, block)
          end
        end

      end
    end
  end
end      
ActiveRecord::Base.extend ActiveRecord::Magic::Update::Extend
