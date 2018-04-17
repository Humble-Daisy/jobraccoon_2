# == Schema Information
#
# Table name: tasks
#
#  id             :integer          not null, primary key
#  name           :string
#  notes          :text
#  due_date       :datetime
#  email_reminder :datetime
#  task_type      :string
#  card_id        :integer
#  created_at     :datetime         not null
#  updated_at     :datetime         not null
#  completed      :boolean
#  subline        :string
#  user_id        :integer
#

FactoryBot.define do
  factory :task do
    name "MyString"
    notes "MyText"
    due_date "2017-10-10 16:06:52"
    email_reminder "2017-10-10 16:06:52"
    type ""
    card nil
  end
end
