module CylonArena
  class ExplosionWrapper
    attr_accessor :image_sequence
    def initialize(window)
       @image_sequence = (0..14).map do |i|
         Gosu::Image.new(window, File.join(File.dirname(__FILE__),"../media/images/explosion#{i.to_s.rjust(2, '0')}.bmp"))
       end
    end
  end
end