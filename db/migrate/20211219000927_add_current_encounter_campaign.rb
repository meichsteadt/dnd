class AddCurrentEncounterCampaign < ActiveRecord::Migration[5.2]
  def change
    add_column :campaigns, :active_display, :json, default: {}
    add_column :campaigns, :default_display, :json, default: {}
  end
end
