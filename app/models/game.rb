class Game < ActiveRecord::Base
  STD_CONFIG = "Standard"
  attr_accessible :name, :points, :status, :config
  has_many :player_games    
  has_many :players, through: :player_games
  
  #
  # Add a player to this game
  #
  def add_player(p)
    if (!p.nil? and Player.exists?(p.id))
      pg = PlayerGame.new(:game_id => self.id, :player_id => p.id)
      pg.save
    end
  end
  
  def add_round()
    r = Round.new
    
    
    
  end
  
  
end
