class ApplicationController < ActionController::Base
  before_action :authenticate_user!
  before_action :edit_mode
  before_action :remove_subs

  attr_reader :character

  def remove_subs
    return if session[:campaign_subs].nil? || session[:campaign_subs].empty?
    session[:campaign_subs].each do |room_id|
      campaign = Campaign.find_by(room: room_id)
      if request.url != room_path(campaign.room)
        campaign.remove_player(current_user.id)
      end
      # ActionCable.server.broadcast "rooms_#{room_id}", campaign: campaign, players: campaign.get_players
    end
    session[:campaign_subs] = []
  end

  def edit_mode
    if params[:edit_mode]
      session[:edit_mode] = params[:edit_mode] == "true"
    end
    @edit_mode = session[:edit_mode] ? session[:edit_mode] : false
  end

  def add_campaign_to_subs(campaign)
    session[:campaign_subs] ||= []
    session[:campaign_subs] << campaign.room
  end

  def current_character(character = nil)
    if character
      session[:character_id] = character
      @character = Character.find(session[:character_id])
    else
      return nil if session[:character_id].nil?
      @character ||= Character.find(session[:character_id])
    end
  end
end
