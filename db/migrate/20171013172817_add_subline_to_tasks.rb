class AddSublineToTasks < ActiveRecord::Migration
  def change
    add_column :tasks, :subline, :string
  end
end
