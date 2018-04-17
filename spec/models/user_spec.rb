# == Schema Information
#
# Table name: users
#
#  id                     :integer          not null, primary key
#  email                  :string           default(""), not null
#  encrypted_password     :string           default(""), not null
#  reset_password_token   :string
#  reset_password_sent_at :datetime
#  remember_created_at    :datetime
#  sign_in_count          :integer          default(0), not null
#  current_sign_in_at     :datetime
#  last_sign_in_at        :datetime
#  current_sign_in_ip     :inet
#  last_sign_in_ip        :inet
#  confirmation_token     :string
#  confirmed_at           :datetime
#  confirmation_sent_at   :datetime
#  unconfirmed_email      :string
#  name                   :string
#  admin                  :boolean          default(FALSE)
#  created_at             :datetime
#  updated_at             :datetime
#

require 'rails_helper'

RSpec.describe User, :type => :model do
  it "has a valid factory" do
  	expect(build(:user)).to be_valid
  end


  context "is invalid without" do
	  it "an email" do
	  	user = build(:user, email: nil)
	  	expect(user).to have(1).errors_on(:email)
	  end
	  it "a password" do
      user = build(:user, password: nil)
      expect(user).to have(1).errors_on(:password)
    end
  end

  context "has dependencies" do
    before :each do 
      @user = create(:user)
    end

    context "destroyed for it" do
    	it "identities" do
        create(:identity, user: @user)
        @user.destroy
        expect(Identity.find_by(user_id: @user.id)).to eq nil
      end
    end
  end
end
