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
  
  def add_all
    unless game.nil? or game.players.nil?
      game.players.each do |p|
        add_player(p)
      end
    end
  end
  
  #
  # submit the scores for each player:score
  #
  def score_round(scores={})

    return nil if scores.nil?
    return nil unless game.in_play?
    
    total = scores.values.inject(0){|score,value| score+value}
    return nil unless total == 26

    scores.each_pair do |name,score|
      playa = game.players.select{|p| p.name == name}.first
      pr = playa.player_rounds.select{|pr| pr.round_id == self.id}.first
      if pr
        total += score
        pr.score = score
        pr.save
      end
    end

    game.calculate_totals
    
  end
  
  
end
