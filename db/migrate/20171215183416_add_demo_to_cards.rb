class AddDemoToCards < ActiveRecord::Migration
  def change
    add_column :cards, :demo, :boolean
  end
end
