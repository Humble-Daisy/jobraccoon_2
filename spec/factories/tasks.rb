FactoryGirl.define do
  factory :task do
    name "MyString"
    notes "MyText"
    due_date "2017-10-10 16:06:52"
    email_reminder "2017-10-10 16:06:52"
    type ""
    card nil
  end
end
