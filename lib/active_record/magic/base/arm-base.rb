require "active_record"
require "strip_attributes"
ActiveRecord::Base.raise_in_transactional_callbacks = true

module ActiveRecord
  module Magic

    load "active_record/magic/base/arm-byebug.rb"
    load "active_record/magic/base/arm-exception.rb"
    load "active_record/magic/base/ruby-hash.rb"
    load "active_record/magic/base/arm-proc.rb"
    load "active_record/magic/base/ruby-metaclass.rb"
    load "active_record/magic/base/ruby-number.rb"
    load "active_record/magic/base/ruby-string.rb"
    load "active_record/magic/base/arm-connect.rb"
    load "active_record/magic/base/arm-value.rb"

  end
end
