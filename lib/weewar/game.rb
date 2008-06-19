module Weewar
  class Game < Base
    self.base_url = "http://weewar.com/api1/game"
    self.xml_options = {'ForceArray' => false, "GroupTags" => {'players' => 'player'}}

    integer_attr :id, :round, :pace, :creditsPerBase, :initialCredits
    string_attr :name, :url, :state, :type
    boolean_attr :pendingInvites
    time_attr :playingSince
    
    def players
      @players ||= Array(@data['players']).map do |name| 
        name = String === name ? name : name['content']
        User.find(name)
      end
    end
    
    def current_player
      @current_player ||= User.find Array(@data['players']).find do |u|
        Hash === u && u['current'] == 'true'
      end
    end
  end
end