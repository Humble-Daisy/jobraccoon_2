class CreateBoards < ActiveRecord::Migration
  def change
    create_table :boards do |t|
      t.references :user, index: true, foreign_key: true
      t.text :name

      t.timestamps null: false
    end
  end
end
