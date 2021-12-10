class CreatePages < ActiveRecord::Migration[5.2]
  def change
    create_table :pages do |t|
      t.integer :chapter_id
      t.integer :order
      t.text :html

      t.timestamps
    end
  end
end
