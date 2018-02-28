class Card < ActiveRecord::Base
  belongs_to :swimlane
  has_many :tasks, :dependent => :destroy

  scope :last_week, lambda { where("created_at >= :date", :date => 1.week.ago) }
  scope :by_position, -> { order("position ASC") }
end
