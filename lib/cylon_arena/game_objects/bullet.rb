module CylonArena
  class Bullet < GameObject
    attr_accessor :arena, :origin, :firepower
    def initialize(args={})
      args.each { |k,v| send("#{k}=", v) }
      @x += Math::sin(@heading * Math::PI / 180.0) * 40
      @y += Math::cos(@heading * Math::PI / 180.0) * 40
    end
    
    def tick
      return if dead?
      super
      
      @dead = (@x < 0 || @x > @arena.width) || (@y < 0 || @y > @arena.height)
      @arena.robots.each do |robot|
        if (robot != origin) && (Math.hypot(@y - robot.y, robot.x - @x) < 40) && (!robot.dead?)  
          robot.hit(self)
          @dead = true
          fire_event :bullet_collision, robot
        end
      end
    end
  end
end
