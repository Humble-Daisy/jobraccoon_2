class Board < ActiveRecord::Base
  belongs_to :user
  has_many :swimlanes, -> { order("swimlanes.id ASC") }
  has_many :cards
end
