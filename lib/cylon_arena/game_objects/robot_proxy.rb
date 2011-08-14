module CylonArena
  class RobotProxy
    attr_reader :x, :y, :energy, :heat, :velocity, :heading, :gun_heading, :radar_heading 
    attr_reader :time, :width, :height
    attr_reader :events
    attr_reader :actions
    
    def initialize(opts)
      opts.each do |name, value|
        instance_variable_set("@#{name}",value)
      end
    end
    
    def turn(degrees)
      @actions[:turn] = degrees
    end
    
    def turn_gun(degrees)
      @actions[:turn_gun] = degrees
    end
    
    def turn_radar(degrees)
      @actions[:turn_radar] = degrees
    end
    
    def accelerate(velocity)
      @actions[:accelerate] = velocity
    end
        
    def fire(energy)
      @actions[:fire] = energy
    end
  end
end