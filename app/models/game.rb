class Game < ActiveRecord::Base
  STANDARD = "Standard"
  FINISHED = "Finished"
  IN_PLAY="In Play"
  
  attr_accessible :name, :points, :status, :config, :num_rounds, :winner
  attr_accessor :scores_by_player
  has_many :player_games    
  has_many :players, through: :player_games
  has_many :rounds
  before_create :set_defaults
  
  # TODO make name mandatory


  def in_play?
    status == IN_PLAY
  end
  
  def finished?
    status == FINISHED
  end
  
  def calculate_totals
    self.scores_by_player = {}
    finished = false
    return nil if points.nil?
    players.each do |p|
      score = p.player_rounds.inject(0){|sum,pr| sum+pr.score}
      self.scores_by_player[p]=score
      finished = true if score >= points
    end
    
    if finished
      self.status = FINISHED
      who_won
    else
      self.add_round
    end

    self.save
    return scores_by_player
    
  end
  
  def who_won
    min = nil
    self.scores_by_player.each_pair do |player,score|
      if (min.nil? or score < min)
        min = score
        winner = player.name
      end
    end
  end
  
  #
  # Add a player to this game
  #
  def add_player(p)
    if (!p.nil? and Player.exists?(p.id))
      self.players << p
      self.save
    end
  end
  
  def add_round(r=Round.new)
    if in_play?
      self.rounds << r
      r.add_all
      self.num_rounds = self.rounds.size
      r.position = self.num_rounds
      r.pass = self.next_pass
      r.save
      self.save
    end
  end

  
  #
  #
  #
  def next_pass
    std_pass if self.config == Game::STANDARD
  end
  

private

  def set_defaults
    self.status = IN_PLAY
    self.num_rounds = 0
    self.config = STANDARD
    self.points = 100
  end
  
  def std_pass
    return nil if num_rounds == 0
    return Round::RIGHT if num_rounds%4 == 1
    return Round::LEFT if num_rounds%4 == 2
    return Round::ACROSS if num_rounds%4 == 3
    return Round::NO_PASS if num_rounds%4 == 0
  end
  
end
