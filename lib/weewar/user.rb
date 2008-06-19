module Weewar
  class User < Base
    self.base_url = 'http://weewar.com/api1/user'
    self.xml_options = {
      'ForceArray' => false, 
      'GroupTags' => {
        'games' => 'game', 
        'players' => 'player', 
        'favoriteUnits' => 'unit',
        'preferredBy' => 'player',
        'preferredPlayers' => 'player'}
    }

    integer_attr :id, :points, :basesCaptured, :creditsSpent, :victories, 
                 :losses, :draws, :gamesRunning
    boolean_attr :on, :readyToPlay
    string_attr :name, :profile, :profileImage, :accountType, :profileText
    time_attr :lastLogin

    def maps
      # TODO
      []
    end

    def games
      @games ||= Array(@data['games']).map do |g|
        Game.find(g)
      end
    end

    def favoriteUnits
      @data['favoriteUnits'].map {|h| h['code'] }
    end

    def preferredPlayers
      @preferredPlayers ||= Array(@data['preferredPlayers']).map do |u|
        User.find(u['name'] || u['id'])
      end
    end
    
    def preferredBy
      @preferredBy ||= Array(@data['preferredBy']).map do |u|
        User.find(u['name'] || u['id'])
      end
    end
  end
end