class Player < ActiveRecord::Base
  attr_accessible :handle, :name
  has_many :player_rounds
  has_many :player_games  
  has_many :games, through: :player_games
  
  #
  # Join a game
  #
  def join(game_id)
    if Game.exists?(game_id)
      pg = PlayerGame.new(:game_id => game_id, :player_id => self.id)
      pg.save
    end
  end
  
  
  
  
end
