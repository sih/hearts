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


end