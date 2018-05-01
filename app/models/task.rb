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

class Task < ApplicationRecord
  default_scope { order("created_at DESC") }
  belongs_to :card, optional: true
	scope :overdue, -> {  where("due_date < ? AND (completed != true OR completed IS NULL)", Time.now) }
	scope :upcoming, -> {  where("due_date > ? AND (completed != true OR completed IS NULL)", Time.now) }
	scope :incomplete, -> {  where("(completed != true OR completed IS NULL)").order(due_date: :desc) }
	scope :today, -> {  where("(due_date = ?)", Date.today).order(due_date: :desc) }
	scope :every, -> {  order(due_date: :desc) }
end
