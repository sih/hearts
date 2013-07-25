require "spec_helper"

describe Game do

  valid_params = {:name => "Tour de Hearts", :points => 2013}

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
    end
    
    it "shouldn't create a player game record when the player doesn't exist" do
      @g.add_player(Player.new)
      PlayerGame.count.should == 0
    end
    
    it "should navigate from the player game to its parents" do
      @g.add_player(@p)
      pg = PlayerGame.first
      pg.game.should eq(@g)
      pg.player.should eq(@p)
    end
    
  end


end