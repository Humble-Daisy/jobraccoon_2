class CreateCards < ActiveRecord::Migration
  def change
    create_table :cards do |t|
      t.references :swimlane, index: true, foreign_key: true
      t.text :company
      t.text :title
      t.text :logo
      t.text :location
      t.text :salary
      t.text :url
      t.text :description
      t.integer :position

      t.timestamps null: false
    end
  end
end
