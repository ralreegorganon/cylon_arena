module CylonArena
  class Leaderboard
    FONT_COLORS = [0xffffffff, 0xff0008ff, 0xfffff706, 0xffff0613, 0xff00ff04]
    def initialize(window, robots)
      @font_size = 24 
      @robots = robots
      @font = Gosu::Font.new(window, 'Courier New', @font_size) 
    end

    def draw
      if @robots
        @robots.each do |r, w|
          y = @y_offset +  w.index* @font_size
          @font.draw("#{r.ai.class.name}: #{r.energy.to_i}", @font_size, y, ZOrder::UI, 1.0, 1.0, FONT_COLORS[w.index])
        end
      end
    end
  end
end