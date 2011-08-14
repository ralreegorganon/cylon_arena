module CylonArena
  class Explosion 
    attr_accessor :t, :x, :y, :dead
    def initialize(arena, x, y)
      @arena, @x, @y, @t, @dead = arena, x, y, 0, false
    end
    
    def tick
      @t += 1
      @dead = t>13
    end
  end
end
