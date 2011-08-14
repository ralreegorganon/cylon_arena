module CylonArena
  class DamageTakenEvent
    attr_accessor :damage, :energy_remaining
    def initialize(damage, energy_remaining)
      @damage, @energy_remaining = damage, energy_remaining
    end
  end
end
