class EncounterMonstersController < ApplicationController
  def update
    @monster = EncounterMonster.find(params[:id])
    respond_to do |format|
      if @monster.update(monster_params)
        format.html { redirect_to @monster, notice: "Encounter was successfully updated." }
        format.json { render :show, status: :ok, location: @monster }
        format.js
      else
        format.html { render :edit, status: :unprocessable_entity }
        format.json { render json: @monster.errors, status: :unprocessable_entity }
        format.js
      end
    end
  end

  def destroy
    @id = params[:id]
    respond_to do |format|
      format.js
    end
  end

  private

  def monster_params
    params.permit(:current_health)
  end
end
