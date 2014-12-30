class CreateProblems < ActiveRecord::Migration
  def change
    create_table :problems do |t|
      t.string :title
      t.text :statement
      t.text :solution
      t.integer :status, default: 0
      t.integer :difficulty, default: 0
      t.belongs_to :domain, index: true
      t.belongs_to :author, index: true

      t.timestamps
    end
  end
end
