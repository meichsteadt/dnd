class NpcsController < ApplicationController
  before_action :set_npc, only: %i[ show edit update destroy ]

  # GET /npcs or /npcs.json
  def index
    @npcs = Npc.all
  end

  # GET /npcs/1 or /npcs/1.json
  def show
    @show = params[:show] == "true"
    respond_to do |format|
      format.html
      format.js
      format.json {render @npc}
    end
  end

  # GET /npcs/new
  def new
    @monster = Monster.find(params[:monster_id]) if params[:monster_id]
    @path = new_npc_path
    @npc = @monster ? Npc.new(@monster.attributes.except(*Npc.not_accepted_keys)) : Npc.new

    @npc.base = @monster if @monster
    respond_to do |format|
      format.html
      format.js
    end
  end

  # GET /npcs/1/edit
  def edit
    @monster = Monster.find(params[:monster_id]) if params[:monster_id]
    @path = edit_npc_path(@npc)
    if @monster
      @monster.attributes.except(:_type, :type, :_id, :name).each {|k,v| @npc[k] = v}
      @npc.base = @monster
    end

    respond_to do |format|
      format.html
      format.js { render 'new.js.erb'}
    end
  end

  # POST /npcs or /npcs.json
  def create
    @npc = Npc.new(npc_params)
    @npc.user_id = current_user.id
    monster = Monster.find(params[:npc][:monster_id])
    @npc.base = monster
    Npc.hidden_attributes.each {|field| @npc[field] = monster[field]}
    @npc.user_id = current_user.id
    @npc._type = 'Npc'
    @npc.save
    respond_to do |format|
      if @npc.save
        format.html { redirect_to @npc, notice: "Npc was successfully created." }
        format.json { render :show, status: :created, location: @npc }
      else
        format.html { render :new, status: :unprocessable_entity }
        format.json { render json: @npc.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /npcs/1 or /npcs/1.json
  def update
    respond_to do |format|
      if @npc.update(npc_params)
        monster = Monster.find(params[:npc][:monster_id])
        @npc.base = monster
        Npc.hidden_attributes.each {|field| @npc[field] = monster[field]}
        @npc.user_id = current_user.id
        @npc._type = 'Npc'
        @npc.save
        format.html { redirect_to edit_npc_path @npc, notice: "Npc was successfully updated." }
        format.json { render :show, status: :ok, location: @npc }
      else
        format.html { render :edit, status: :unprocessable_entity }
        format.json { render json: @npc.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /npcs/1 or /npcs/1.json
  def destroy
    @npc.destroy
    respond_to do |format|
      format.html { redirect_to npcs_url, notice: "Npc was successfully destroyed." }
      format.json { head :no_content }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_npc
      @npc = Monster.find(params[:id])
    end

    # Only allow a list of trusted parameters through.
    def npc_params
      params.require(:npc).permit(*Npc.accepted_keys + [:name, :base, :_type => [:name, :desc]])
    end

    def map_actions
      params[:npc][:proficiencies].gsub("=>", ":")
    end
end
