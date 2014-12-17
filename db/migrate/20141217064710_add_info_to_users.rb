class AddInfoToUsers < ActiveRecord::Migration
  def change
    add_column :users, :facebook, :string
    add_column :users, :school, :string
  end
end
