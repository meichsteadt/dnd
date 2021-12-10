class AddPageName < ActiveRecord::Migration[5.2]
  def change
    add_column :pages, :name, :string, default: ''
  end
end
