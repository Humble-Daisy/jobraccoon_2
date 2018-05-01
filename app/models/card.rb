# == Schema Information
#
# Table name: cards
#
#  id          :integer          not null, primary key
#  swimlane_id :integer
#  company     :string
#  title       :string
#  logo        :string
#  location    :string
#  salary      :string
#  url         :string
#  description :text
#  position    :integer
#  created_at  :datetime         not null
#  updated_at  :datetime         not null
#  user_id     :integer
#  demo        :boolean
#

class Card < ApplicationRecord
  belongs_to :swimlane, optional: true
  has_many :tasks, :dependent => :destroy

  scope :last_week, lambda { where("created_at >= :date", :date => 1.week.ago) }
  scope :by_position, -> { order("position ASC") }
end
