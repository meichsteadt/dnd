class ChangeCampaignPlayersIdString < ActiveRecord::Migration[5.2]
  def change
    remove_column :campaigns, :players, :integer, array: true
    add_column :campaigns, :players, :string, array: true, default: []
  end
end
