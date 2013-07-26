class PlayerRound < ActiveRecord::Base
  attr_accessible :player_id, :round_id, :score, :led, :got_queen
  belongs_to :player
  belongs_to :round
  
  before_create :set_defaults
  after_create :add_game_id
  
  private
  
  def set_defaults
    self.score = 0
  end
  
  def add_game_id
    self.game_id = self.round.game_id
    self.save
  end
  
end
