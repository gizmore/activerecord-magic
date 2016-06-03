module ActiveRecord
  module Magic
    module Block
      
      @@duplicates = {}
      
      def self.display(proc)
        (file, line = *proc.source_location) or raise ActiveRecord::Magic::RuntimeError.new("No sourcecode line for proc: #{proc.inspect}")
        "#{file} #{line}"
      end

      def self.position(block)
        block.source_location.join
      end
      
      def self.duplicate?(object, block)
        pos = "#{object.object_id}@#{position(block)}"
        return true if @@duplicates.has_key?(pos)
        @@duplicates[pos] = true
        false
      end
      
      def self.deduplicate(object, block)
        byebug
        pos = "#{object.object_id}@#{position(block)}"
        @@duplicates.delete(pos)
      end
      
    end
  end
end