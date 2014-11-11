class AddThumbnailToAsset < ActiveRecord::Migration
  def change
    add_column :assets, :thumbnails, :text
  end
end
