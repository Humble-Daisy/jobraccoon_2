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

require 'rails_helper'

RSpec.describe Task, type: :model do
  pending "add some examples to (or delete) #{__FILE__}"
end
