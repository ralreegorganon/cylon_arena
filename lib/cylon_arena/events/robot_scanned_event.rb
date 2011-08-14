module CylonArena
  class RobotScannedEvent
    attr_accessor :distance
    def initialize(distance)
      @distance = distance
    end
  end
end
