module CylonArena
  class Robot < GameObject
    attr_accessor :ai, :arena, :proxy
    attr_accessor :size, :energy, :heat, :gun_heading, :radar_heading, :old_radar_heading
    attr_accessor :ai_events
    
    def initialize(ai, arena, args={})
      super()
      {
        :x => rand(arena.width),
        :y => rand(arena.height),
        :gun_heading => rand(360),
        :size => 40, 
        :heat => 0, 
        :energy => 100
      }.merge!(args).each { |k,v| send("#{k}=", v) }
      
      @arena, @ai, @ai_events = arena, ai, Hash.new{|h, k| h[k]=[]}
      @radar_heading = @old_radar_heading = @gun_heading      
    end
        
    def turn(degrees)
      degrees = clamp(degrees, -10, 10)
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
      degrees = clamp(degrees, -45, 45)
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
      bullet = Bullet.new(:x => @x, :y => @y, :heading => @gun_heading, :velocity => 20.0-3.0*firepower, :firepower => 4.0*firepower, :origin => self, :arena => @arena)
      @arena.add_bullet(bullet)
    end
    
    def dead?
      @dead = @energy <= 0
    end
    
    def hit(bullet)
      @energy -= bullet.firepower
      @dead = @energy <= 0
      @ai_events[:damage_taken] << DamageTakenEvent.new(:damage => bullet.firepower, :energy_remaining => @energy)
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
            @ai_events[:robot_scanned] << RobotScannedEvent.new(:distance => distance)
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