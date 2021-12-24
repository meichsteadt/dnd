class RoomsController < ApplicationController
  before_action :set_campaign
  before_action :set_character

  def show
    @campaign = Campaign.find_by(room: params[:room])
    @campaign.add_player(@character._id.to_s) unless @campaign.user_id == current_user.id
    @players = @campaign.get_players

    respond_to do |format|
      format.html
      format.js
    end
  end

  private

  def set_campaign
    @campaign = Campaign.find_by(room: params[:room])
  end

  def set_character
    @character = current_character
    redirect_to new_set_character_path(redirect: request.url) unless @character
  end
end
