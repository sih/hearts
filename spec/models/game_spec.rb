require "spec_helper"

describe Game do

  valid_params = {:name => "Tour de Hearts", :points => 2013}
  
  
  describe "when creating a game" do
    
    before(:each) do
      @g = Game.new(valid_params)
      @g.save.should be_true
      
      @g = Game.find(@g.id)
    end
    
    it "should default the status to in play" do
      @g.status.should == Game::IN_PLAY
      @g.in_play?.should be_true
    end
    
    it "should default the number of rounds to zero" do
      @g.num_rounds.should == 0
    end
    
    it "should default the config to standard" do
      @g.config.should == Game::STANDARD
    end
    
  end
  

  describe "when adding players" do
    
    before(:each) do
      @g = Game.new(valid_params)
      @g.valid?.should be_true
      @g.save.should be_true
      
      p = Player.new(:name => "Sid")
      p.save.should be_true
      
      @p= Player.find(p.id)
      
      PlayerGame.count.should == 0
      
    end
    
    it "should create a player game record when the player exists" do
      @g.add_player(@p)
      PlayerGame.count.should == 1
      @g.players.count.should == 1
    end
    
    it "shouldn't create a player game record when the player doesn't exist" do
      @g.add_player(Player.new)
      PlayerGame.count.should == 0
      @g.players.count.should == 0      
    end
    
    it "should navigate from the player game to its parents" do
      @g.add_player(@p)
      pg = PlayerGame.first
      pg.game.should eq(@g)
      pg.player.should eq(@p)
    end
    
  end

  describe "when adding rounds" do
    
    describe "and for a standard config" do
      
      before(:each) do
        @g = Game.new(valid_params)
        @g.save.should be_true

        
        @p1 = Player.new({:name => 'Jas'})
        @p2 = Player.new({:name => 'Joe'})
        @p3 = Player.new({:name => 'Kate'})
        @p4 = Player.new({:name => 'Sid'})          
        
        @p1.save.should be_true              
        @p2.save.should be_true              
        @p3.save.should be_true              
        @p4.save.should be_true              
                                
        @g.add_player(@p1)
        @g.add_player(@p2)
        @g.add_player(@p3)
        @g.add_player(@p4)

        @g.rounds.should be_empty
        @g.players.size.should == 4

        @g.num_rounds.should == 0        
        @g.add_round      
        @g = Game.find(@g.id)

      end

      it "should add a round to the game" do
        @g.rounds.size.should == 1
      end

      it "should add all players to the round" do
        r = @g.rounds.first
        r.players.size.should == 4
        r.players.include?(@p1).should be_true
        r.players.include?(@p2).should be_true
        r.players.include?(@p3).should be_true
        r.players.include?(@p4).should be_true                        
      end

      it "should increment the round position" do
        r = @g.rounds.first
        r.position.should == 1
      end
      
      it "should increment the number of rounds for the game" do
        @g.num_rounds.should == 1
      end

    end
    
    
  end

  describe "when calculating the pass" do
    
    describe "in a standard config" do
      
      before(:each) do
        @g = Game.new(valid_params)
        @g.save.should be_true

        @g = Game.find(@g.id)
        @g.rounds.size.should == 0
      end
      
      it "should set the pass to nil if there are no rounds" do
        @g.next_pass.should be_nil
      end
      
      it "should set the pass to right for the first round" do
        @g.add_round
        @g.next_pass.should == Round::RIGHT
        @g.rounds.last.pass.should == Round::RIGHT        
      end

      it "should set the pass to right for the second round" do
        @g.add_round
        @g.add_round        
        @g.next_pass.should == Round::LEFT
        @g.rounds.last.pass.should == Round::LEFT        
      end      
      
      it "should set the pass to right for the third round" do
        @g.add_round
        @g.add_round        
        @g.add_round                
        @g.next_pass.should == Round::ACROSS
        @g.rounds.last.pass.should == Round::ACROSS        
      end      
      
      
      it "should set the pass to right for the third round" do
        @g.add_round
        @g.add_round        
        @g.add_round                
        @g.add_round                
        @g.next_pass.should == Round::NO_PASS
        @g.rounds.last.pass.should == Round::NO_PASS
      end      
      
      
    end
    
  end

  describe "when calculating totals" do
    
    before(:each) do
      @g = Game.new(valid_params)
      @g.save.should be_true
      
      @g = Game.find(@g.id)
      
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
      @okay_scores = {"jas" => 10, "joe" => 10, "sid" => 3, "kate" => 3}
      @more_okay_scores = {"jas" => 1, "joe" => 1, "sid" => 24, "kate" => 0}
      
    end
    
    it "should set the status of the game to finished if the game closes" do
      @g.points = 10
      @g.save
      @r.score_round(@okay_scores)
      @g = Game.find(@g.id)
      @g.status.should == Game::FINISHED
    end
    
    it "should set the summary scores of each player in the game" do
      scores = @r.score_round(@okay_scores)
      scores.each_pair do |player,score|
        score.should == 10 if player.name == "jas" 
        score.should == 10 if player.name == "joe"
        score.should == 3 if player.name == "kate"
        score.should == 3 if player.name == "sid"                           
      end
    end
    
    it "should create a new round if the game is not finished" do
      @g.rounds.size.should == 1
      scores = @r.score_round(@okay_scores)
      @g = Game.find(@g.id)
      @g.rounds.size.should == 2      
    end
    
    it "should calculate scores for multiple rounds" do
      scores = @r.score_round(@okay_scores)
      @g = Game.find(@g.id)
      new_round = @g.rounds.last
      new_round.should_not == @r
      latest_scores = new_round.score_round(@more_okay_scores)
      latest_scores.each_pair do |player,score|
        score.should == 11 if player.name == "jas" 
        score.should == 11 if player.name == "joe"
        score.should == 3 if player.name == "kate"
        score.should == 27 if player.name == "sid"                           
      end
    end
  end


end