class PlayerGame < ActiveRecord::Base
  attr_accessible :game_id, :player_id
  belongs_to :game
  belongs_to :player
end
