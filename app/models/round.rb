class Round < ActiveRecord::Base
  attr_accessible :pass, :position, :winner, :game_id
  has_many :player_rounds
  belongs_to :game
  
  RIGHT = "R"
  LEFT = "L"
  ACROSS = "A"
  NO_PASS = "X"
  
  PASS_ORDER = [RIGHT,LEFT,ACROSS,NO_PASS]
  
  def add_player(player=nil)
    unless (player.nil? or !player.games.include?(game))
      pr = PlayerRound.new(:round_id => self.id, :player_id => player.id)
      pr.save
    end
  end
  
  def add_all()
    unless game.nil? or game.players.nil?
      game.players.each do |p|
        add_player(p)
    end
    end
  end
  
  
  #
  #
  #
  def next_pass(last_pass=RIGHT)
    
  end
  
  
end
