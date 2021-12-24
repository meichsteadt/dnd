class EncountersController < ApplicationController
  before_action :set_encounter, only: %i[ show edit update destroy add_monster]
  before_action :set_campaign
  # GET /encounters or /encounters.json
  def index
    @encounters = Encounter.all
  end

  # GET /encounters/1 or /encounters/1.json
  def show
    @target = params[:target] ? params[:target] : "encounter_card"
    @start_encounter = params[:start_encounter] == "true"
    @readonly = params[:readonly] == "true"
    if @start_encounter
      @encounter.reset if !@encounter.started
      @encounter.characters = CharacterArray[*@campaign.get_players]
      @encounter.save
      @campaign.set_active_display(@encounter)
      ActionCable.server.broadcast "rooms_#{@campaign.room}", campaign: @campaign, encounter_id: @encounter.id.to_s
    end
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
        @encounter.update(monsters: map_monsters)
        @encounter.update(npcs: map_npcs)
        format.html { redirect_to edit_encounter_path(@encounter), notice: "Encounter was successfully created." }
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
        @encounter.update(monsters: map_monsters)
        @encounter.update(characters: map_characters)
        @encounter.update(npcs: map_npcs)
        format.html { redirect_to edit_encounter_path(@encounter), notice: "Encounter was successfully updated." }
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
    @monster_type = params[:monster_type]
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

    def set_campaign
      @campaign = Campaign.find_by(room: params[:room])
    end

    # Only allow a list of trusted parameters through.

    # Only allow a list of trusted parameters through.
    def encounter_params
      params.require(:encounter).permit(:name, :player_level, :n_players, :notes, :started)
    end

    def encounter_monster_params
      params.require(:encounter).permit(:encounter_monsters => [:id, :current_health, :initiative, :hp, :monster_id, :currency_type, :currency_amount])[:encounter_monsters]
    end

    def encounter_npc_params
      params.require(:encounter).permit(:encounter_npcs => [:id, :npc_id, :current_health, :initiative, :hp, :ids => [:id], :npc_ids => [:id]])[:encounter_npcs]
    end

    def character_params
      params.require(:encounter).permit(:characters => [:id, :current_health, :initiative])[:characters]
    end

    def map_npcs
      return EncounterMonsterArray[*@encounter.npcs] if encounter_npc_params.nil?

      npcs = encounter_npc_params.map do |e|
        begin
          npc = @encounter.find_npc(e[:id].to_s)
          npc.current_health = e[:current_health]
          if !e[:initiative].nil? && !e[:initiative].empty?
            npc.initiative = e[:initiative]
          else
            npc.roll_for_initiative unless npc.initiative
          end
          npc
        rescue
          npc = Npc.find(e[:id])
          amount = Random.rand(100)
          currency = Currency.new(amount: amount, type: Currency.types[Random.rand(Currency.types.count)])
          EncounterNpc.new(
            monster: npc,
            loot_currency: currency,
            current_health: npc.hit_points
          )
        end
      end.flatten
      EncounterMonsterArray[*(npcs)]
    end

    def map_characters
      return CharacterArray[*@encounter.characters] if character_params.nil?
      characters = character_params.map do |e|
        character = Character.find(e[:id])
        character.current_health = e[:current_health]
        if !e[:initiative].nil? && !e[:initiative].empty?
          character.initiative = e[:initiative]
        else
          character.roll_for_initiative unless character.initiative
        end
        character.save
        character
      end
      CharacterArray[*characters]
    end

    def map_monsters
      return EncounterMonsterArray[*@encounter.monsters] if encounter_monster_params.nil?
      monsters = encounter_monster_params.map do |e|
        if e[:id]
          monster = @encounter.find_monster(e[:id].to_s)
          monster ||= @encounter.find_npc(e[:id].to_s)
          monster.current_health = e[:current_health]
          if !e[:initiative].nil? && !e[:initiative].empty?
            monster.initiative = e[:initiative]
          else
            monster.roll_for_initiative unless monster.initiative
          end
          monster
        else
          monster = Monster.find(e[:monster_id])
          amount = e[:currency_amount].empty? ? 0 : e[:currency_amount].to_i
          currency = Currency.new(amount: amount, type: e[:currency_type])
          EncounterMonster.new(
            monster: monster,
            loot_currency: currency,
            current_health: e[:hp]
          )
        end
      end
      EncounterMonsterArray[*(monsters)]
    end
end
