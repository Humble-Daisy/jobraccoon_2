# == Schema Information
#
# Table name: global_configs
#
#  id                      :integer          not null, primary key
#  app_name                :string
#  app_domain              :string
#  facebook_app_id         :string
#  twitter_app_id          :string
#  linkedin_app_id         :string
#  use_slack               :boolean          default(FALSE)
#  slack_team              :string
#  slack_icon_url          :string
#  slack_user              :string
#  technical_support_email :string
#  technical_slack_channel :string
#  feedback_support_email  :string
#  feedback_slack_channel  :string
#  default_email_address   :string
#  default_slack_channel   :string
#  created_at              :datetime
#  updated_at              :datetime
#

require 'rails_helper'

RSpec.describe GlobalConfig, :type => :model do
  it "has a valid factory" do
  	config = build(:global_config)
  	expect(config).to be_valid
  end
end
