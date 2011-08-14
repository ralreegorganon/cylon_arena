module CylonArena
  class BulletWrapper
    attr_reader :image
    def initialize(window)
       @image = Gosu::Image.new(window, File.join(File.dirname(__FILE__),"../media/images/bullet.png"))
    end
  end
end