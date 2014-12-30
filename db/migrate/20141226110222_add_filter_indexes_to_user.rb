class AddFilterIndexesToUser < ActiveRecord::Migration
  def change
  	add_index :users, [:username, :master]
  	add_index :users, [:username, :status]
  end
end
