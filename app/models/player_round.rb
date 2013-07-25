class PlayerRound < ActiveRecord::Base
  attr_accessible :player_id, :round_id, :score, :led, :got_queen
  belongs_to :player
  belongs_to :round
end
