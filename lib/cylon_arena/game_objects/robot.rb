module CylonArena
  class Robot < GameObject
    attr_accessor :ai
    attr_accessor :energy, :heat
    attr_accessor :gun_heading, :radar_heading, :old_radar_heading
    attr_accessor :ai_events
    attr_accessor :proxy
    
    def initialize(ai, arena)
      @arena = arena
      @ai = ai
      @size = 40
      @heat, @energy = 0, 100
      @x, @y, @heading, @gun_heading, @radar_heading, @old_radar_heading, @velocity = rand(800),rand(800), 0,0,0,0,0
      @ai_events = Hash.new{|h, k| h[k]=[]}
    end
        
    def turn(degrees)
      degrees = clamp(degrees, -20, 20)
      @heading += degrees
      @gun_heading += degrees
      @radar_heading += degrees
      @heading %= 360
      @gun_heading %= 360
      @radar_heading %= 360
    end
    
    def turn_gun(degrees)
      degrees = clamp(degrees, -20, 20)
      @gun_heading += degrees
      @radar_heading += degrees
      @gun_heading %= 360
      @radar_heading %= 360
    end
    
    def turn_radar(degrees)
      degrees = clamp(degrees, -20, 20)
      @radar_heading += degrees
      @radar_heading %= 360
    end
    
    def accelerate(velocity)
      accel = clamp(velocity, -1, 1)
      @velocity += accel
      @velocity = clamp(@velocity, -velocity.abs, velocity.abs)
    end
        
    def fire(firepower)
      return if @heat != 0
      firepower = clamp(firepower,0.1,3)
      @heat += 1.0 + firepower/5.0
      bullet = Bullet.new(@arena, @x, @y, @gun_heading, 20.0-3.0*firepower, 4.0*firepower, self)
      @arena.add_bullet(bullet)
    end
    
    def dead?
      @dead = @energy <= 0
    end
    
    def hit(bullet)
      @energy -= bullet.firepower
      @dead = @energy <= 0
      @ai_events[:damage_taken] << DamageTakenEvent.new(bullet.firepower, @energy)
    end
    
    def scan
      @arena.robots.each do |robot|
        if (robot != self) && (!robot.dead?)
          a = (Math.atan2(robot.x - @x, robot.y - @y) / Math::PI * 180) % 360 
          scan_degrees = ((@old_radar_heading - @radar_heading + 180.0)%360.0-180.0).abs
          target_diff_degrees = ((@old_radar_heading - a + 180.0)%360.0-180.0).abs
          in_range_inc = @old_radar_heading <= a && a <= @radar_heading && @old_radar_heading <= @radar_heading
          in_range_dec = @old_radar_heading >= a && a >= @radar_heading && @old_radar_heading >= @radar_heading
        
          if ((in_range_inc && !in_range_dec) || (!in_range_inc && in_range_dec)) && (target_diff_degrees <= scan_degrees) 
            distance = Math.hypot(robot.y - @y, robot.x - @x)
            @ai_events[:robot_scanned] << RobotScannedEvent.new(distance)
          end
        end
      end
    end
    
    def tick
      @proxy = generate_proxy
      @old_radar_heading = @radar_heading
      @ai.tick(@proxy)
      @ai_events.clear
      fire(@proxy.actions[:fire]) if @proxy.actions.has_key? :fire
      turn(@proxy.actions[:turn]) if @proxy.actions.has_key? :turn
      turn_gun(@proxy.actions[:turn_gun]) if @proxy.actions.has_key? :turn_gun
      turn_radar(@proxy.actions[:turn_radar]) if @proxy.actions.has_key? :turn_radar
      accelerate(@proxy.actions[:accelerate]) if @proxy.actions.has_key? :accelerate
      super
      @x = clamp(@x, @size, @arena.width-@size)
      @y = clamp(@y, @size, @arena.height-@size)
      @heat = clamp(@heat-0.1, 0, @heat-0.1)
      scan
    end
    
    def generate_proxy
      state = {
        :x => @x, 
        :y => @y, 
        :energy => @energy, 
        :heat => @heat, 
        :velocity => @velocity, 
        :heading => @heading, 
        :gun_heading => @gun_heading, 
        :radar_heading => @radar_heading,
        :old_radar_heading => @old_radar_heading,
        :time => @arena.time,
        :width => @arena.width,
        :height => @arena.height,
        :actions => {},
        :events => @ai_events
      }
      
      RobotProxy.new(state)
    end
    
    def clamp(value, min, max)
      [min,[value,max].min].max
    end
  end
end