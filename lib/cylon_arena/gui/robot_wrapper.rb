module CylonArena
  COLORS = ['white', 'blue', 'yellow', 'red', 'lime'] 
  class RobotWrapper
    attr_reader :body_image, :gun_image, :radar_image, :color, :index, :robot
    def initialize(window, robot, index, draw)
      @draw = draw
      @window = window
      @robot = robot
      @index = index
      @color = COLORS[index % COLORS.size]
      @body_image = Gosu::Image.new(window, File.join(File.dirname(__FILE__),"../media/images/#{@color}_body000.bmp"))
      @gun_image = Gosu::Image.new(window, File.join(File.dirname(__FILE__),"../media/images/#{@color}_turret000.bmp"))
      @radar_image = Gosu::Image.new(window, File.join(File.dirname(__FILE__),"../media/images/#{@color}_radar000.bmp"))
    end
    
    def draw
      return if @robot.dead?
      @body_image.draw_rot(@robot.x, @window.height - @robot.y, ZOrder::Robot, @robot.heading)
      @gun_image.draw_rot(@robot.x, @window.height - @robot.y, ZOrder::Robot, @robot.gun_heading)
      @radar_image.draw_rot(@robot.x, @window.height - @robot.y, ZOrder::Robot, @robot.radar_heading)
      @robot.ai.draw(@window, @robot.proxy) if @robot.ai.respond_to?(:draw) and @draw
    end
  end
end