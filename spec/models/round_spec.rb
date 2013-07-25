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
      
    end
    
    it "should add all players where there are players in a game" do
        @r.add_all
        PlayerRound.count.should  == 2
    end
    
    it "should add no players where there are none" do
      @r.game_id = @v.id
      @r.add_all()
    end
    
    
    
    
  end


end