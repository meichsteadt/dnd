class EncountersController < ApplicationController
  before_action :set_encounter, only: %i[ show edit update destroy add_monster]

  # GET /encounters or /encounters.json
  def index
    @encounters = Encounter.all
  end

  # GET /encounters/1 or /encounters/1.json
  def show
    respond_to do |format|
      format.html
      format.json
      format.js
    end
  end

  # GET /encounters/new
  def new
    @encounter = Encounter.new
    respond_to do |format|
      format.html
      format.json
      format.js
    end
  end

  # GET /encounters/1/edit
  def edit
    respond_to do |format|
      format.html
      format.json
      format.js
    end
  end

  # POST /encounters or /encounters.json
  def create
    @encounter = Encounter.new(encounter_params)

    respond_to do |format|
      if @encounter.save
        format.html { redirect_to @encounter, notice: "Encounter was successfully created." }
        format.json { render :show, status: :created, location: @encounter }
        format.js { render 'show.js.erb' }
      else
        format.html { render :new, status: :unprocessable_entity }
        format.json { render json: @encounter.errors, status: :unprocessable_entity }
        format.js { render 'show.js.erb' }
      end
    end
  end

  # PATCH/PUT /encounters/1 or /encounters/1.json
  def update
    respond_to do |format|
      if @encounter.update(encounter_params)
        format.html { redirect_to @encounter, notice: "Encounter was successfully updated." }
        format.json { render :show, status: :ok, location: @encounter }
        format.js
      else
        format.html { render :edit, status: :unprocessable_entity }
        format.json { render json: @encounter.errors, status: :unprocessable_entity }
        format.js
      end
    end
  end

  # DELETE /encounters/1 or /encounters/1.json
  def destroy
    @encounter.destroy
    respond_to do |format|
      format.html { redirect_to encounters_url, notice: "Encounter was successfully destroyed." }
      format.json { head :no_content }
      format.js
    end
  end

  def add_monster
    respond_to do |format|
      format.js
    end
  end

  def new_monster
    respond_to do |format|
      format.js
    end
  end

  def total_difficulty
    @n_players = params[:n_players]
    @player_level = params[:player_level]
    @total_xp = params[:total_xp]
    @n_monsters = params[:n_monsters]
    @difficulty = Encounter.get_difficulty(n_players: @n_players, player_level: @player_level, total_xp: @total_xp, n_monsters: @n_monsters)
    respond_to do |format|
      format.js
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_encounter
      @encounter = Encounter.find(params[:id])
    end

    # Only allow a list of trusted parameters through.
    def encounter_params
      params.fetch(:encounter, {})
    end

    # Only allow a list of trusted parameters through.
    def encounter_monster_params
      params.fetch(:encounter, {})
    end
end
