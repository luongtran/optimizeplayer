class AddVideoIdToAsset < ActiveRecord::Migration
  def change
    add_column :assets, :video_id, :string
  end
end
