class AddIndexUpdatedAtToProblems < ActiveRecord::Migration
  def change
  	add_index :problems, [:updated_at]
  end
end
