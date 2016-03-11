##
# File is included twice.
class EventDuplicateDecorate
  arm_events
  # this dup should always be detected
  arm_subscribe('test3') do; end
  def subscribe
    # This is not a duplicate, when object_id differs
    arm_subscribe('test4') do; end
  end
end
