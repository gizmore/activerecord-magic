module ActiveRecord
  module Magic
    module Update
      class Step

        attr_reader :dependencies

        def initialize(dependencies={}, block)
          @dependencies = dependencies
          @block = block
        end

        def has_block?(block)
          @block.source_location.join == block.source_location.join
        end

        def run
          migration = ActiveRecord::Migration.new
          @block.call(migration)
        end

      end
    end
  end
end
