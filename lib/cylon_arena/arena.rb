module CylonArena
  class Arena
    attr_accessor :robots, :bullets
    attr_accessor :width, :height, :time
    
    def initialize(width, height, match, timeout, ais)
      @width, @height, @timeout, @time = width, height, timeout, 0
      srand(match)    
      @robots, @bullets = [],[]
      ais.each {|ai| add_robot_with_ai(ai)}     
    end
    
    def add_robot_with_ai(ai)
      robot = Robot.new(ai, self)
      @robots << robot
    end
    
    def add_bullet(bullet)
      @bullets << bullet
    end
    
    def tick           
      @bullets.delete_if(&:dead)
      @bullets.each(&:tick)
    
      @robots.each do |robot|
        robot.tick unless robot.dead?
      end
      
      @time += 1
    end
  end
end