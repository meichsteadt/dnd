class CreateCampaigns < ActiveRecord::Migration[5.2]
  def change
    create_table :campaigns do |t|
      t.integer :user_id
      t.string :name
      t.string :desc

      t.timestamps
    end
  end
end
