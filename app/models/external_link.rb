class ExternalLink < ActiveRecord::Base
  mount_uploader :image, ExternalLinkImageUploader
  attr_accessible :title, :url, :active, :image, :image_cache
end
