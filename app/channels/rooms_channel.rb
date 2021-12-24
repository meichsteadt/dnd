class RoomsChannel < ApplicationCable::Channel
  def subscribed
    puts "\n\n\n" + '='*20 + 'SUB' + '='*20 +"\n\n\n"
    @campaign = Campaign.find_by(room: params[:room])
    @campaign.add_player(params[:character_id]) if params[:character_id]
    ActionCable.server.broadcast "rooms_#{@campaign.room}", campaign: @campaign, players: @campaign.get_players, from: "sub"
    stream_from "rooms_#{params[:room]}"
  end

  def unsubscribed
    puts "\n\n\n" + '*'*20 + 'UNSUB' + '*'*20 +"\n\n\n"
    @campaign = Campaign.find_by(room: params[:room])
    @campaign.remove_player(params[:character_id])
    ActionCable.server.broadcast "rooms_#{@campaign.room}", campaign: @campaign, players: @campaign.get_players, from: "unsub"
  end
end
