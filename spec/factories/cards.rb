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

FactoryBot.define do
  factory :card do
    swimlane nil
    company "MyText"
    title "MyText"
    logo "MyText"
    location "MyText"
    salary "MyText"
    url "MyText"
    description "MyText"
    position 1
  end
end
