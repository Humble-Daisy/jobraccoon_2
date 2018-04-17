# == Schema Information
#
# Table name: swimlanes
#
#  id         :integer          not null, primary key
#  board_id   :integer
#  name       :text
#  position   :integer
#  icon       :text
#  created_at :datetime         not null
#  updated_at :datetime         not null
#

class Swimlane < ActiveRecord::Base
  belongs_to :board
  has_many :cards
  has_many :tasks
end
