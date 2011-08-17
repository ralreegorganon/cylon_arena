require 'gosu'

module CylonArena
  module ZOrder
    Background, Robot, Explosions, UI = *0..3
  end
  
  class GuiArena < Gosu::Window    
    def initialize(width, height, arena)
      super(width, height, false, 16)
      @arena = arena
      intialize_wrappers(@arena.robots)
      @leaderboard = Leaderboard.new(self, @arena.robots)
      @explosions = []
      
      Bullet.on_event(:bullet_collision) do |bullet, robot| 
        @explosions << Explosion.new(self, robot.x, robot.y)
      end
    end
    
    def intialize_wrappers(robots)
      @robot_wrappers = {}
      robots.each_with_index do |robot, i|
        @robot_wrappers[robot] = RobotWrapper.new(self,robot,i)
      end
      
      @bullet_wrapper =  BulletWrapper.new(self)
    end
    
    def draw
      process_keys   
      @arena.tick
      draw_robots(@arena.robots)
      draw_bullets(@arena.bullets)
      draw_explosions
      @leaderboard.draw
    end
    
    def draw_robots(robots)
      robots.each_with_index do |robot, i|
        next if robot.dead?
        @robot_wrappers[robot].body_image.draw_rot(robot.x, self.height - robot.y, ZOrder::Robot, robot.heading)
        @robot_wrappers[robot].gun_image.draw_rot(robot.x, self.height - robot.y, ZOrder::Robot, robot.gun_heading)
        @robot_wrappers[robot].radar_image.draw_rot(robot.x, self.height - robot.y, ZOrder::Robot, robot.radar_heading)
        
        #draw_triangle()
        self.draw_triangle( 
          robot.x,  self.height-robot.y, Gosu::Color::WHITE,
           (robot.x + Math::sin(robot.radar_heading * Math::PI / 180.0) * 1200), self.height - (robot.y + Math::cos(robot.radar_heading * Math::PI / 180.0) * 1200), Gosu::Color::WHITE,
              (robot.x + Math::sin(robot.old_radar_heading * Math::PI / 180.0) * 1200), self.height - (robot.y + Math::cos(robot.old_radar_heading * Math::PI / 180.0) * 1200), Gosu::Color::WHITE
                  )   
      end
    end
    
    def draw_bullets(bullets)
      bullets.each do |bullet|
        @bullet_wrapper.image.draw_rot(bullet.x, self.height - bullet.y, ZOrder::Explosions,0)
      end
    end
    
    def draw_explosions()
      @explosions.delete_if(&:dead)
      @explosions.each do |explosion|
        explosion.image_sequence[explosion.t].draw_rot(explosion.x, self.height - explosion.y, ZOrder::Explosions,0)
        explosion.tick
      end
    end
    
    def process_keys
      if button_down? Gosu::Button::KbEscape
        self.close
      end
    end
  end
end