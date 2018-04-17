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

require 'rails_helper'

RSpec.describe Card, type: :model do
  pending "add some examples to (or delete) #{__FILE__}"
end
