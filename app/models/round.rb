class Round < ActiveRecord::Base
  attr_accessible :pass, :position, :winner
  has_many :player_rounds
  belongs_to :game
end
