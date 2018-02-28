class CreateTasks < ActiveRecord::Migration
  def change
    create_table :tasks do |t|
      t.string :name
      t.text :notes
      t.datetime :due_date
      t.datetime :email_reminder
      t.string :task_type
      t.references :card, index: true, foreign_key: true

      t.timestamps null: false
    end
  end
end
