class CharactersController < ApplicationController
  before_action :set_character, only: %i[ show edit update destroy ]

  # GET /characters or /characters.json
  def index
    @characters = current_user.characters
  end

  # GET /characters/1 or /characters/1.json
  def show
  end

  # GET /characters/new
  def new
    @character = Character.new
    @redirect = params[:redirect]
  end

  # GET /characters/1/edit
  def edit
  end

  # POST /characters or /characters.json
  def create
    @character = Character.new(character_params)
    respond_to do |format|
      if @character.save
        redirect = params[:redirect] ? params[:redirect] : edit_character_path
        set_object_character_params
        @character.save
        format.html { redirect_to redirect, notice: "Character was successfully created." }
        format.json { render :show, status: :created, location: @character }
      else
        format.html { render :new, status: :unprocessable_entity }
        format.json { render json: @character.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /characters/1 or /characters/1.json
  def update
    respond_to do |format|
      if @character.update(character_params)
        set_object_character_params
        @character.save
        format.html { redirect_to edit_character_path(@character), notice: "Character was successfully updated." }
        format.json { render :show, status: :ok, location: @character }
      else
        format.html { render :edit, status: :unprocessable_entity }
        format.json { render json: @character.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /characters/1 or /characters/1.json
  def destroy
    @character.destroy
    respond_to do |format|
      format.html { redirect_to characters_url, notice: "Character was successfully destroyed." }
      format.json { head :no_content }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_character
      @character = Character.find(params[:id])
    end

    # Only allow a list of trusted parameters through.
    def character_params
      params.require(:character).permit(:hit_points, :armor_class, :name)
    end

    def set_object_character_params
      _p = params.require(:character).permit(:race, :character_class, :alignment)
      @character.set_race(_p[:race])
      @character.set_character_class(_p[:character_class])
      @character.set_alignment(_p[:alignment])
      @character.user_id = current_user.id
      # @character._type = 'Character'
    end
end
