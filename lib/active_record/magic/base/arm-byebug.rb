# Define byebug for production, in case the devs accidently left a byebug call
unless Object.respond_to?(:byebug)
  class Object
    def byebug
    end
  end
end
