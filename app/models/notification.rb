class Notification < ActiveRecord::Base
  attr_accessible :description, :notification_type, :title, :url

  has_and_belongs_to_many :users

  validates :notification_type, inclusion: { in: %w(News Bug Feature), message: "%{value} is not a valid notification type" }
end
