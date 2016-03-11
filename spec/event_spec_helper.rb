##
# File is included twice.
class EventDuplicateDecorate
  arm_events
  # Dup should be detected
  arm_subscribe('test3') do; end
  def subscribe
    # This is not a dup!
    arm_subscribe('test4') do; end
  end
end
