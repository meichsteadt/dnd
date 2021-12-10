class CreateChapters < ActiveRecord::Migration[5.2]
  def change
    create_table :chapters do |t|
      t.integer :campaign_id
      t.integer :order
      t.string :name
      t.string :desc
      t.integer :book_id

      t.timestamps
    end
  end
end
