class Swimlane < ActiveRecord::Base
  belongs_to :board
  has_many :cards
  has_many :tasks
end
