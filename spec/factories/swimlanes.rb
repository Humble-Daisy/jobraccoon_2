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

FactoryBot.define do
  factory :swimlane do
    board nil
    name "MyText"
    position 1
    icon "MyText"
  end
end
