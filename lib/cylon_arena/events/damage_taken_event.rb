module CylonArena
  class DamageTakenEvent
    attr_accessor :damage, :energy_remaining
    def initialize(args={})
      {
         :damage => 0, 
         :energy_remaining => 0
      }.merge!(args).each { |k,v| send("#{k}=", v) }
    end

    def to_json(*a)
    	{ 
    		:damage => @damage, 
    		:energy_remaining => @energy_remaining
		}.to_json(*a) 
    end
  end
end
