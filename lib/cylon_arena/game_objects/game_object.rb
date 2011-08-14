module CylonArena
  class GameObject
    attr_accessor :x, :y, :heading, :velocity, :dead
    def initialize(x, y, heading, velocity)
      @x, @y, @heading, @velocity = x, y, heading, velocity, false
    end
    
    def tick
      @x += Math::sin(@heading * Math::PI / 180.0) * @velocity
      @y += Math::cos(@heading * Math::PI / 180.0) * @velocity
    end
    
    def dead?
      return @dead
    end

  end
end
