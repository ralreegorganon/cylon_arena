module CylonArena
  class GameObject
    @@events = Hash.new{|h, k| h[k]=[]}
    
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
    
    def self.on_event(event, &block)
      @@events[event] << block
    end
    
    def fire_event(event, *args)
      data = [self] + args
      @@events[event].each {|e| e.call *data}
    end

  end
end
