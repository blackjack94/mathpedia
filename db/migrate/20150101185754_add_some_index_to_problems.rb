class AddSomeIndexToProblems < ActiveRecord::Migration
  def change
  	add_index :problems, [:status]
  	add_index :problems, [:difficulty]
  	add_index :problems, [:domain_id, :status]
  	add_index :problems, [:domain_id, :status, :difficulty]
  end
end
