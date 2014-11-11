class AddKeepVideoSizeToAsset < ActiveRecord::Migration
  def change
    add_column :assets, :keep_video_size, :bool, default: false
  end
end
