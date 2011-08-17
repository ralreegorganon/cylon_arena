module CylonArena
  class RobotScannedEvent
    attr_accessor :distance
    def initialize(args={})
      {
         :distance => 0
      }.merge!(args).each { |k,v| send("#{k}=", v) }
    end
  end
end
