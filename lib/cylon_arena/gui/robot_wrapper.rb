module CylonArena
  COLORS = ['white', 'blue', 'yellow', 'red', 'lime'] 
  class RobotWrapper
    attr_reader :body_image, :gun_image, :radar_image, :color, :index
    def initialize(window, index)
      @index = index
      @color = COLORS[index % COLORS.size]
      @body_image = Gosu::Image.new(window, File.join(File.dirname(__FILE__),"../media/images/#{@color}_body000.bmp"))
      @gun_image = Gosu::Image.new(window, File.join(File.dirname(__FILE__),"../media/images/#{@color}_turret000.bmp"))
      @radar_image = Gosu::Image.new(window, File.join(File.dirname(__FILE__),"../media/images/#{@color}_radar000.bmp"))
    end
  end
end