# == Schema Information
#
# Table name: identities
#
#  id         :integer          not null, primary key
#  user_id    :integer
#  provider   :string
#  uid        :string
#  created_at :datetime
#  updated_at :datetime
#

class Identity < ActiveRecord::Base
  belongs_to :user
  validates_presence_of :uid, :provider, :user_id
  validates_uniqueness_of :uid, :scope => :provider

  # def self.find_for_oauth(auth)
  # 	find_or_create_by(uid: auth.id, provider: auth.provider)
  # end
    def self.find_for_oauth(auth)
	    identity = find_by(provider: auth.provider, uid: auth.uid)
	    identity = create(uid: auth.uid, provider: auth.provider) if identity.nil?
	    identity
  end
end
