class CreateBooks < ActiveRecord::Migration[5.2]
  def change
    create_table :books do |t|
      t.integer :campaign_id
      t.integer :order
      t.string :name
      t.string :desc

      t.timestamps
    end
  end
end
