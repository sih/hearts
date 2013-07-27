require "spec_helper"

describe Round do
  
  before(:each) do
    @g = Game.new(:name => "Tour de Hearts")
    @g.save
    
    @p = Player.new(:name => "Sid")
    @p.valid?.should be_true
    @p.save.should be_true

    @g.add_player(@p)
    
    @valid_params = {:pass => "R", :game_id => @g.id}
    
    PlayerRound.count.should == 0
  end

  describe "when adding players" do
    
    before(:each) do
      @r = Round.new(:game_id => @g.id)
      @r.save.should be_true
    end
    
    it "should create a player round record when valid" do
      @r.add_player(@p)
      PlayerRound.count.should == 1      
    end
    
    it "shouldn't create a player round when the game id doesn't match" do
      @r.game_id = 100-@r.game_id
      @r.add_player(@p)
      PlayerRound.count.should == 0
    end
    
  end
  
  describe "when adding all players" do
    before(:each) do
      @q = Player.new(:name => "Kate")
      @q.save.should be_true
      @g.add_player(@q)

      PlayerRound.count.should == 0
      
      @v = Game.new(:name => "Hoo")
      
      @r = Round.new(:game_id => @g.id)
      @r.save
      
    end
    
    it "should add all players where there are players in a game" do
        @r.add_all
        @r = Round.find(@r.id)
        @r.players.count.should == 2
    end
    
    it "should add no players where there are none" do
      @r.game_id = @v.id
      @r.add_all()
      @r = Round.find(@r.id)
      @r.players.count.should == 0
      
    end
    
    
    
    
  end


  describe "when scoring a round" do
    
    before(:each) do
      @p1 = Player.new(:name => "jas")
      @p1.save.should be_true
      @p2 = Player.new(:name => "joe")
      @p2.save.should be_true      
      @p3 = Player.new(:name => "kate")
      @p3.save.should be_true      
      @p4 = Player.new(:name => "sid")                  
      @p4.save.should be_true
      
      @g.add_player(@p1)
      @g.add_player(@p2)
      @g.add_player(@p3)
      @g.add_player(@p4)                  
      
      @g.add_round
      @g = Game.find(@g.id)
      @g.rounds.size.should == 1
      
      @r = @g.rounds.first

      @too_high_scores = {"jas" => 10, "joe" => 10, "sid" => 10, "kate" => 10}
      @okay_scores = {"jas" => 10, "joe" => 10, "sid" => 3, "kate" => 3}
      @mon_shot = {"jas" => 26, "joe" => 26, "sid" => 26, "kate" => 0}      
      
    end
    
    it "should return nil if the scores don't add up to 26" do
      @r.score_round(@too_high_scores).should be_nil
    end
    
    it "should not put a score in the players scores if the scores don't add up to 26" do
      @r.score_round(@too_high_scores)      
      pr = @p1.player_rounds.first
      pr.should_not be_nil
      pr.score.should == 0
    end
    
    it "should return nil if the scores are nil" do
      @r.score_round.should be_nil
    end
    
    it "should not put a score in the players scores if the scores are nil" do
      @r.score_round
      pr = @p1.player_rounds.first
      pr.should_not be_nil
      pr.score.should == 0
    end
    
    it "should not score a round if the game is not in play" do
      @g.status = Game::FINISHED
      @g.save.should be_true
      @r.score_round(@okay_scores).should be_nil
    end
    
    it "should add the score to each of the players" do
      @r.score_round(@okay_scores).should_not be_nil
      g = Game.find(@g.id)
      g.players.each do |playa|
        pr = playa.player_rounds.select{|pround| pround.round_id = @r.id}.first
        if playa.name == "jas"
          pr.score.should == 10
        elsif playa.name == "joe"
          pr.score.should == 10          
        elsif playa.name == "kate"
          pr.score.should == 3          
        elsif playa.name == "sid"
          pr.score.should == 3          
        end
      end
    end
    
    it "should recognize shooting the moon" do
      @r.score_round(@mon_shot).should_not be_nil
      g = Game.find(@g.id)
      g.players.each do |playa|
        pr = playa.player_rounds.select{|pround| pround.round_id = @r.id}.first
        if playa.name == "jas"
          pr.score.should == 26
          pr.mon_shot.should be_false                             
        elsif playa.name == "joe"
          pr.score.should == 26          
          pr.mon_shot.should be_false                   
        elsif playa.name == "kate"
          pr.score.should == 0 
          pr.mon_shot.should be_true         
        elsif playa.name == "sid"
          pr.score.should == 26          
          pr.mon_shot.should be_false                             
        end
      end      
    end
    
  end

end