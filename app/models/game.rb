class Game < ActiveRecord::Base
  attr_accessible :name, :points, :status
  has_many :player_games    
  
  #
  # Add a player to this game
  #
  def add_player(player_id)
    if Player.exists?(player_id)
      pg = PlayerGame.new(:game_id => self.id, :player_id => player_id)
      pg.save
    end
  end
  
  
end
