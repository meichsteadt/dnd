class DropCharacters < ActiveRecord::Migration[5.2]
  def change
    drop_table :characters
  end
end
