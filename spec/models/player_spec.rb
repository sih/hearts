require "spec_helper"

describe Player do

  valid_params = {:name => "Sid", :handle => "sid"}

  describe "when joining games" do
    
    before(:each) do
      @p = Player.new(valid_params)
      @p.valid?.should be_true
      @p.save.should be_true
      
      g = Game.new(:name => "Tour de Hearts")
      g.save.should be_true
      
      @g= Game.find(g.id)
      
      PlayerGame.count.should == 0
      
    end
    
    it "should create a player game record when the game exists" do
      @p.join(@g.id)
      PlayerGame.count.should == 1
    end
    
    it "shouldn't create a player game record when the game doesn't exist" do
      @p.join(@g.id*100)
      PlayerGame.count.should == 0
    end
    
    it "should navigate from the player game to its parents" do
      @p.join(@g.id)
      pg = PlayerGame.first
      pg.game.should eq(@g)
      pg.player.should eq(@p)
    end
    
    
  end

  describe "when calculating points" do
    
    before(:each) do
      g = Game.new(:name => "Tour de Hearts")
      g.save.should be_true
      
      p1 = Player.new(:name => "sid")
      p1.save
      
      p2 = Player.new(:name => "kate")
      p2.save
      
      g.add_player(p1)
      g.add_player(p2)      
      
      r = g.add_round
      r.score_round({"sid" => 20, "kate" => 6})

      r = g.add_round
      r.score_round({"sid" => 26, "kate" => 0})
      
      @g = Game.find(g.id)
      @p1 = Player.find(p1.id)
      @p2 = Player.find(p2.id)      
      
    end
    
    it "should return the right number of points" do
      @p1.points(@g.id).should == 46
      @p2.points(@g.id).should == 6
    end
    
    it "should return nil for a non-existent game id" do
      Game.exists?(2).should be_false
      @p1.points(2).should be_nil
    end
    
    it "should return nil when no game id is supplied" do
      @p1.points(nil).should be_nil      
    end
    
  end

end