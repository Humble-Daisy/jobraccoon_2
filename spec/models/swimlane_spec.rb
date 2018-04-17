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

require 'rails_helper'

RSpec.describe Swimlane, type: :model do
  pending "add some examples to (or delete) #{__FILE__}"
end
