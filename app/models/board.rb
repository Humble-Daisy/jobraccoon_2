# == Schema Information
#
# Table name: boards
#
#  id         :integer          not null, primary key
#  user_id    :integer
#  name       :text
#  created_at :datetime         not null
#  updated_at :datetime         not null
#

class Board < ActiveRecord::Base
  belongs_to :user
  has_many :swimlanes, -> { order("swimlanes.id ASC") }
  has_many :cards
end
