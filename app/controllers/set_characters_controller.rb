class SetCharactersController < ApplicationController
  def new
    @redirect = params[:redirect]
  end

  def create
    current_character(character_id)
    redirect_to params[:redirect]
  end

  private

  def character_id
    params.permit(:character_id)[:character_id]
  end
end
