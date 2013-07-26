require "spec_helper"

describe GamesController do
  describe "routing" do

    it "routes to #index" do
      get("/games").should route_to("games#index")
    end

    it "routes to #new" do
      get("/games/new").should route_to("games#new")
    end

    it "routes to #show" do
      get("/games/1").should route_to("games#show", :id => "1")
    end

    it "routes to #edit" do
      get("/games/1/edit").should route_to("games#edit", :id => "1")
    end

    it "routes to #create" do
      post("/games").should route_to("games#create")
    end

    it "routes to #update" do
      put("/games/1").should route_to("games#update", :id => "1")
    end

    it "routes to #destroy" do
      delete("/games/1").should route_to("games#destroy", :id => "1")
    end
    
    it "routes to #add_player" do
      post("games/1/player/10").should route_to("games#add_player", :id => "1", :player_id => "10")
    end
    
    it "routes to #rounds" do
      get("games/1/rounds").should route_to("games#rounds", :id => "1")
    end
    
    it "routes to #score_round" do
      post("games/1/round/2/score").should route_to("games#score_round", :id => "1", :round_id => "2")
    end

  end
end
