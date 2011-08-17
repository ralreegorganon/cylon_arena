module CylonArena
  class GameObject
    attr_accessor :x, :y, :heading, :velocity, :dead
    
    def initialize
      @x, @y, @heading, @velocity, @dead = 0,0,0,0,false
    end
    
    def tick
      @x += Math::sin(@heading * Math::PI / 180.0) * @velocity
      @y += Math::cos(@heading * Math::PI / 180.0) * @velocity
    end
    
    def dead?
      return @dead
    end
    
    @@events = Hash.new{|h, k| h[k]=[]}
    def self.on_event(event, &block)
      @@events[event] << block
    end
    
    def fire_event(event, *args)
      data = [self] + args
      @@events[event].each {|e| e.call *data}
    end
  end
end
