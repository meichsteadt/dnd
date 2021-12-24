class AddNotesCampaign < ActiveRecord::Migration[5.2]
  def change
    add_column :campaigns, :notes, :text, default: ''
  end
end
