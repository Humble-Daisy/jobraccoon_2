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

class User < ActiveRecord::Base

  has_many :boards
  has_many :swimlanes
  has_many :cards
  has_many :tasks
  # has_one :dashboard

	# Define what an email should look like
	TEMP_EMAIL_PREFIX = 'change@me'
	TEMP_EMAIL_REGEX = /\Achange@me/

  # Include default devise modules. Others available are:
  #  :lockable, :timeoutable
  devise :database_authenticatable, :registerable, :omniauthable,
         :recoverable, :rememberable, :trackable, :validatable

  after_save :setup_profile, on: :create

  def self.find_for_oauth(auth, signed_in_resource = nil)

    # Get the identity and user if they exist
    identity = Identity.find_for_oauth(auth)

    # If a signed_in_resource is provided it always overrides the existing user
    # to prevent the identity being locked with accidentally created accounts.
    # Note that this may leave zombie accounts (with no associated identity) which
    # can be cleaned up at a later date.
    user = signed_in_resource ? signed_in_resource : identity.user

    # Create the user if needed
    if user.nil?

      # Get the existing user by email if the provider gives us a verified email.
      # If no verified email was provided we assign a temporary email and ask the
      # user to verify it on the next step via UsersController.finish_signup
      email_is_verified = auth.info.email && (auth.info.verified || auth.info.verified_email)
      email = auth.info.email if email_is_verified
      user = User.where(:email => email).first if email

      # Create the user if it's a new registration
      if user.nil?
        user = User.new(
          name: auth.extra.raw_info.name,
          #username: auth.info.nickname || auth.uid,
          email: email ? email : "#{TEMP_EMAIL_PREFIX}-#{auth.uid}-#{auth.provider}.com",
          password: Devise.friendly_token[0,20]
        )
        user.skip_confirmation!
        user.save!
      end
    end

    # Associate the identity with the user if needed
    if identity.user != user
      identity.user = user
      identity.save!
    end
    user
  end

  def email_verified?
    self.email && self.email !~ TEMP_EMAIL_REGEX
  end

  def is_admin?
    self.admin
  end

  protected

def setup_profile
    board = Board.new
    board.name = "My board"
    board.user_id = self.id
    board.save

    # #<Swimlane id: nil, board_id: nil, name: nil, position: nil, icon: nil, created_at: nil, updated_at: nil>
    swimlane = Swimlane.new
    swimlane.name = 'Unprocessed'
    swimlane.board_id = board.id
    swimlane.save
    swimlane_1_id = swimlane.id

    swimlane = Swimlane.new
    swimlane.name = 'Applied'
    swimlane.board_id = board.id
    swimlane.save
    swimlane_2_id = swimlane.id

    swimlane = Swimlane.new
    swimlane.name = 'In contact'
    swimlane.board_id = board.id
    swimlane.save
    swimlane_3_id = swimlane.id

    swimlane = Swimlane.new
    swimlane.name = 'Interviewed'
    swimlane.board_id = board.id
    swimlane.save
    swimlane_4_id = swimlane.id

    swimlane = Swimlane.new
    swimlane.name = 'Received offer'
    swimlane.board_id = board.id
    swimlane.save
    swimlane_5_id = swimlane.id

    swimlane = Swimlane.new
    swimlane.name = 'Rejected'
    swimlane.board_id = board.id
    swimlane.save
    swimlane_6_id = swimlane.id

    #<Card id: nil, swimlane_id: nil, company: nil, title: nil, logo: nil, location: nil, salary: nil, url: nil, description: nil, position: nil, created_at: nil, updated_at: nil, user_id: nil>

      job_titles = ['Assessor',
      'Auditor',
      'Bookkeeper',
      'Budget Analyst',
      'Cash Manager',
      'Chief Financial Officer',
      'Controller',
      'Credit Manager',
      'Financial Analyst',
      'Hedge Fund Manager',
      'Hedge Fund Principal',
      'Hedge Fund Trader',
      'Investment Advisor',
      'Investment Banker',
      'Investor Relations Officer',
      'HR Coordinator',
      'HR Specialist',
      'Business Systems Analyst',
      'Content Manager',
      'Content Strategist',
      'Database Administrator',
      'Digital Marketing Manager',
      'Full Stack Developer',
      'Information Architect',
      'Marketing Technologist',
      'Mobile Developer',
      'Project Manager',
      'Social Media Manager',
      'Software Engineer',
      'Systems Engineer',
      'Software Developer',
      'Systems Administrator',
      'User Interface Specialist',
      'Web Analytics Developer',
      'Web Developer',
      'Webmaster',
      'Account Executive',
      'Administrative Assistant',
      'Administrative Manager',
      'Branch Manager',
      'Business Analyst',
      'Business Manager',
      'Chief Executive Officer',
      'Office Manager',
      'Operations Manager',
      'Quality Control Coordinator',
      'Risk Manager',
      'Service Representative']

      cards_to_create = [
        [swimlane_1_id, "Apple", "", "Palo Alto", "$60.000", "apple.com", "", ""],
        [swimlane_1_id, "Google", "", "Beijing", "$60.000", "google.com", "", ""],
        [swimlane_1_id, "General Electric", "Los Angeles", "Pittsburgh", "$50.000", "ge.com", "", ""],
        [swimlane_1_id, "McDonalds", "", "Venice", "$40.000", "mcdonalds.com", "", ""],
        [swimlane_1_id, "IBM", "", "New York", "$60.000", "ibm.com", "", ""],
        [swimlane_1_id, "Hewlett-Packard", "", "Morristown", "$60.000", "hp.com", "", ""],

        [swimlane_2_id, "Spotify", "", "New York", "$60.000", "spotify.com", "", ""],
        [swimlane_2_id, "Home Depot", "", "Mobil", "$31.000", "homedepot.com", "", ""],
        [swimlane_2_id, "Target", "", "Minneapolis", "$60.000", "target.com", "", ""],
        [swimlane_2_id, "United Parcel Service", "", "New York", "$60.000", "ups.com", "", ""],
        [swimlane_2_id, "Deloitte", "", "Berlin", "$60.000", "deloitte.com", "", ""],

        [swimlane_3_id, "Walmart", "", "Santa Fe", "$60.000", "walmart.com", "", ""],
        [swimlane_3_id, "Kroger", "", "Cincinnati", "$40.000", "kroger.com", "", ""],
        [swimlane_3_id, "Amazon", "", "Seattle", "$60.000", "amazon.com", "", ""],

        [swimlane_4_id, "Warby Parker", "", "New York", "$60.000", "warbyparker.com", "", ""],
        [swimlane_4_id, "KPMG", "", "Amsterdam", "$60.000", "kpmg.com", "", ""],

        [swimlane_5_id, "New York Times", "", "New York", "$60.000", "nytimes.com", "", ""],
      ]

      tasks_to_create = [
        ['task', 'Follow up with Bruce', false],
        ['call', 'Called to confirm interview date', false],
        ['task', 'Send my updated resume', true]
      ]

    cards_to_create.each do |card_array|
      card = Card.new
      card.swimlane_id = card_array[0]
      card.company = card_array[1]
      card.title = job_titles.sample
      card.location = card_array[3]
      card.salary = card_array[4]
      card.url = card_array[5]
      card.description = "My description for " + card_array[1]
      card.logo = "https://logo.clearbit.com/" + card_array[5] + "?s=128"
	  card.demo = true
      card.user_id = self.id
      card.created_at = rand(7.days).seconds.ago
      card.save

      # #<Task id: nil, name: nil, notes: nil, due_date: nil, email_reminder: nil, task_type: nil, card_id: nil, created_at: nil, updated_at: nil, completed: nil, subline: nil, user_id: nil>
      tasks_to_create.each do |task_array|
        task = Task.new
        task.task_type = task_array[0]
        task.notes = task_array[1]
        task.card_id = card.id
        task.user_id = self.id
        task.created_at = rand(7.days).seconds.ago
        if task_array[0] == 'task'
          task.due_date = DateTime.now
        end
        task.completed = task_array[2]
        task.save
      end
    end



  end

end
