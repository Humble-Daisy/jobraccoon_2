class ChangeFormatsInCards < ActiveRecord::Migration
  def change
    change_column :cards, :company, :string
    change_column :cards, :title, :string
    change_column :cards, :logo, :string
    change_column :cards, :location, :string
    change_column :cards, :salary, :string
    change_column :cards, :url, :string
  end
end