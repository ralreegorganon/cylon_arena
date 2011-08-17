module CylonArena
  class Explosion
    attr_accessor :image_sequence, :t, :x, :y, :dead
    def initialize(window, x, y)
      @x, @y, @t, @dead = x, y, 0, false
      @image_sequence = (0..14).map do |i|
        Gosu::Image.new(window, File.join(File.dirname(__FILE__),"../media/images/explosion#{i.to_s.rjust(2, '0')}.bmp"))
      end
    end
    
    def tick
      @t += 1
      @dead = t>13
    end
  end
end