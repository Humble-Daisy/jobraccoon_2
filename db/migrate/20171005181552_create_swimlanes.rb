class CreateSwimlanes < ActiveRecord::Migration
  def change
    create_table :swimlanes do |t|
      t.references :board, index: true, foreign_key: true
      t.text :name
      t.integer :position
      t.text :icon

      t.timestamps null: false
    end
  end
end
