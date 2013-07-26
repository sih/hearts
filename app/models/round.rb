class Round < ActiveRecord::Base
  attr_accessible :pass, :position, :winner, :game_id
  has_many :player_rounds
  has_many :players, through: :player_rounds
  belongs_to :game
  
  RIGHT = "R"
  LEFT = "L"
  ACROSS = "A"
  NO_PASS = "X"
  
  def add_player(player=nil)
    unless (player.nil? or !player.games.include?(game))
      self.players << player
    end
  end
  
  def add_all()
    unless game.nil? or game.players.nil?
      game.players.each do |p|
        add_player(p)
    end
    end
  end
  
  
end
