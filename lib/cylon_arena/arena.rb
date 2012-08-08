module CylonArena
  class Arena
    attr_accessor :robots, :bullets
    attr_accessor :width, :height, :match, :timeout, :time
    
    def initialize(ais, options={})
      {
        :width => 800, 
        :height => 800, 
        :match => Time.now.to_i + Process.pid,
        :timeout => 10000,
        :time => 0
      }.merge!(options).each { |k,v| send("#{k}=", v) }
      
      srand(@match)    
      @robots, @bullets = [],[]
      ais.each {|ai| add_robot_with_ai(ai)}    

      puts to_match_attribute_json 
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

    def to_match_attribute_json
      {
        :width => @width,
        :height => @height,
        :match => @match,
        :timeout => @timeout,
      }.to_json
    end
  end
end