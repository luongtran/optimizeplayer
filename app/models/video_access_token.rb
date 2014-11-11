class VideoAccessToken < ActiveRecord::Base
  attr_accessible :project_id, :purchase_id, :token

  belongs_to :project

  before_create do
    self.token = SecureRandom.hex
  end
end
