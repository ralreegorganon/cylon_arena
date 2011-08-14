module CylonArena
  class Arena
    attr_accessor :robots, :bullets, :explosions
    attr_accessor :width, :height, :time
    
    def initialize(width, height, match, timeout, ais)
      @width, @height, @timeout, @time = width, height, timeout, 0
      srand(match)    
      @robots, @bullets, @explosions = [],[],[]
      ais.each {|ai| add_robot_with_ai(ai)}     
    end
    
    def add_robot_with_ai(ai)
      robot = Robot.new(ai, self)
      @robots << robot
    end
    
    def add_bullet(bullet)
      @bullets << bullet
    end
    
    def add_explosion(explosion)
      @explosions << explosion
    end
    
    def tick   
      @explosions.delete_if(&:dead)
      @explosions.each(&:tick)
        
      @bullets.delete_if(&:dead)
      @bullets.each(&:tick)
    
      @robots.each do |robot|
        robot.tick unless robot.dead?
      end
      
      @time += 1
    end
  end
end