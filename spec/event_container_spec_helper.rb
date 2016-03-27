class Player
  arm_events
end

class Party
  arm_events
  def initialize()
    @players = []
  end
  def add_player(player)
    @players.push(player)
  end
  
end

class City
  arm_events
  
  def initialize()
    @parties = []
  end
  def add_player(party)
    @parties.push(party)
  end
  
end

class Area < City
  arm_events
  
end

class Location < Area
  arm_events
  
end

