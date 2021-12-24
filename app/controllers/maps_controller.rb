class MapsController < ApplicationController
  before_action :set_map, only: %i[show]
  before_action :set_campaign

  def show
    @campaign.set_active_display(@map)
    ActionCable.server.broadcast "rooms_#{@campaign.room}", campaign: @campaign
    respond_to do |format|
      format.html
      format.js
    end
  end

private

  def set_map
    @map = Map.find(params[:id])
  end

  def set_campaign
    @campaign = Campaign.find(params[:campaign_id])
  end
end
