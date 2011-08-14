module CylonArena
  class Bullet < GameObject
    attr_accessor :dead, :origin, :firepower
    def initialize(arena, x, y, heading, velocity, firepower, origin)
      @x, @y, @heading, @origin = x, y, heading, origin
      @velocity, @firepower = velocity, firepower
      @arena, @dead = arena, false
      @x += Math::sin(@heading * Math::PI / 180.0) * 40
      @y += Math::cos(@heading * Math::PI / 180.0) * 40
    end
    
    def tick
      return if dead?
      super
      
      @dead ||= (@x < 0) || (@x >= @arena.width)
      @dead ||= (@y < 0) || (@y >= @arena.height)
      
      @arena.robots.each do |robot|
        if (robot != origin) && (Math.hypot(@y - robot.y, robot.x - @x) < 40) && (!robot.dead?)  
          explosion = Explosion.new(@arena, robot.x, robot.y)
          @arena.add_explosion(explosion)
          robot.hit(self)
          @dead = true
        end
      end
    end
  end
end
