class ActiveRecord::Magic::DuplicateEvent < ActiveRecord::Magic::RuntimeError
  
  attr_reader :target, :event, :location
  
  def initialize(target, event, source_location)
    @target = target
    @event = event
    @location = source_location
  end

  def to_s
    "An event block of type #{@event} has been subscribed twice on the same object: #{@location}"
  end

end
