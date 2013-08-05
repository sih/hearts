class GamesController < ApplicationController
  # GET /games
  # GET /games.json
  def index
    @games = Game.all

    respond_to do |format|
      format.html # index.html.erb
      format.json { render json: @games }
    end
  end

  # GET /games/1
  # GET /games/1.json
  def show
    @game = Game.find(params[:id])

    respond_to do |format|
      format.html # show.html.erb
      format.json { render json: @game }
    end
  end

  # GET /games/new
  # GET /games/new.json
  def new
    @game = Game.new

    respond_to do |format|
      format.html # new.html.erb
      format.json { render json: @game }
    end
  end

  # GET /games/1/edit
  def edit
    @game = Game.find(params[:id])
  end

  # POST /games
  # POST /games.json
  def create
    @game = Game.new(params[:game])

    respond_to do |format|
      if @game.save
        format.html { redirect_to @game, notice: 'Game was successfully created.' }
        format.json { render json: @game, status: :created, location: @game }
      else
        format.html { render action: "new" }
        format.json { render json: @game.errors, status: :unprocessable_entity }
      end
    end
  end

  # PUT /games/1
  # PUT /games/1.json
  def update
    @game = Game.find(params[:id])

    respond_to do |format|
      if @game.update_attributes(params[:game])
        format.html { redirect_to @game, notice: 'Game was successfully updated.' }
        format.json { head :no_content }
      else
        format.html { render action: "edit" }
        format.json { render json: @game.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /games/1
  # DELETE /games/1.json
  def destroy
    @game = Game.find(params[:id])
    @game.destroy

    respond_to do |format|
      format.html { redirect_to games_url }
      format.json { head :no_content }
    end
  end
  
  #
  # GET /games/1/player/10
  #
  def add_player
    if Game.exists?(params[:id])
      g = Game.find(params[:id])
      p = Player.find(params[:player_id])
      g.add_player(p)
    end
    
    respond_to do |format|
      format.html {redirect_to game_url(g)}
      format.json {head :no_content}
    end
    
  end
  
  #
  # GET /games/1/rounds
  #
  def rounds
    visualise = (!params[:visualise].nil? and ActiveRecord::ConnectionAdapters::Column.value_to_boolean(params[:visualise]))
    @game = Game.find(params[:id]) if Game.exists?(params[:id])
    respond_to do |format|
      format.html {
        render 'rounds' unless visualise
        render 'vrounds' if visualise 
      }     
      format.js {
        render json: @game.rounds_to_json
      }
    end

  end
  
  #
  # GET /games/1/round/2/score
  #
  def score_round
    # TODO implement this properly (i.e. POST the results up)
    if Game.exists?(params[:id])
      g = Game.find(params[:id])
    
      players = params[:players].split(",")
      scores = params[:scores].split(",")
    
      scores_by_players={}
    
      players.each_with_index do |p,index|
        scores_by_players[p]=scores[index].to_i
      end
      
      round = g.rounds.select{|r| r.position == params[:round_position].to_i}.first
      
      round.score_round(scores_by_players) unless round.nil?
      
      respond_to do |format|
        format.html {redirect_to games_rounds_url(g)}
        format.json {head :no_content}
      end      
      
    end
    
  end
  
  
end
