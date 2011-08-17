module CylonArena
  class Leaderboard
    FONT_COLORS = [0xffffffff, 0xff0008ff, 0xfffff706, 0xffff0613, 0xff00ff04]
    def initialize(window, wrappers)
      @font_size = 24 
      @wrappers = wrappers
      @font = Gosu::Font.new(window, 'Courier New', @font_size) 
    end

    def draw
      if @wrappers
        @wrappers.each do |w|
          y = @font_size + w.index * @font_size
          @font.draw("#{w.robot.ai.class.name}: #{w.robot.energy.to_i}", @font_size, y, ZOrder::UI, 1.0, 1.0, FONT_COLORS[w.index])
        end
      end
    end
  end
end