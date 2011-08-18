require 'gosu'

module CylonArena
  module ZOrder
    Background, Robot, Explosions, UI = *0..3
  end
  
  class GuiArena < Gosu::Window    
    def initialize(width, height, arena, draw, step, rate)
      super(width, height, false, rate)
      @draw, @arena, @step = draw, arena, step
      @explosions, @robot_wrappers = [], []
      intialize_wrappers
      @leaderboard = Leaderboard.new(self, @robot_wrappers)
      @can_tick = true
      
      Bullet.on_event(:bullet_collision) do |bullet, robot| 
        @explosions << Explosion.new(self, robot.x, robot.y)
      end
    end
    
    def intialize_wrappers
      @arena.robots.each_with_index do |robot, i|
        @robot_wrappers << RobotWrapper.new(self, robot, i, @draw)
      end
      
      @bullet_wrapper =  BulletWrapper.new(self)
    end
    
    def draw
      process_keys   
      @arena.tick if @can_tick or not @step  
      draw_robots
      draw_bullets(@arena.bullets)
      draw_explosions
      @leaderboard.draw
      @can_tick = false
    end
    
    def draw_robots
      @robot_wrappers.each do |wrapper|
        wrapper.draw
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
      if button_down? Gosu::Button::KbSpace
        @can_tick = true
      end
    end
  end
end