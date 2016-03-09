#
# enable a global cache table for active record models.
# does slow everything down a bit.
# minimal monkey modification.
#
module ActiveRecord
  module Persistence
    module ClassMethods
      
      def instantiate(attributes, column_types = {})
        klass = discriminate_class_for_record(attributes)
        attributes = klass.attributes_builder.build_from_database(attributes, column_types)
        record = klass.allocate.init_with('attributes' => attributes, 'new_record' => false)
        # filter through cache
        record.respond_to?(:arm_cache?) ? record.class.arm_cached(record) : record
      end
      
    end
  end
end
 
