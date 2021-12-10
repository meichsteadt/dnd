class CreatePlayers < ActiveRecord::Migration[5.2]
  def change
    create_table :players do |t|
      t.string :name
      t.string :character_class
      t.string :character_sheet_url
      t.integer :user_id
      t.integer :health

      t.timestamps
    end
  end
end
