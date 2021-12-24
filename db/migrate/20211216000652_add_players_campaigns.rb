class AddPlayersCampaigns < ActiveRecord::Migration[5.2]
  def change
    add_column :campaigns, :players, :integer, array: true, default: []
  end
end
