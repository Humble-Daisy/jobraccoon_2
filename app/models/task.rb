class Task < ActiveRecord::Base
  default_scope { order("created_at DESC") }
  belongs_to :card
	scope :overdue, -> {  where("due_date < ? AND (completed != true OR completed IS NULL)", Time.now) }
	scope :upcoming, -> {  where("due_date > ? AND (completed != true OR completed IS NULL)", Time.now) }
	scope :incomplete, -> {  where("(completed != true OR completed IS NULL)").order(due_date: :desc) }
	scope :today, -> {  where("(due_date = ?)", Date.today).order(due_date: :desc) }
	scope :every, -> {  order(due_date: :desc) }
end
