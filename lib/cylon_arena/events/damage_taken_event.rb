module CylonArena
  class DamageTakenEvent
    attr_accessor :damage, :energy_remaining
    def initialize(args={})
      {
         :damage => 0, 
         :energy_remaining => 0
      }.merge!(args).each { |k,v| send("#{k}=", v) }
    end
  end
end
