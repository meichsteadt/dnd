class AddRoomCampaigns < ActiveRecord::Migration[5.2]
  def change
    add_column :campaigns, :room, :string
  end
end
