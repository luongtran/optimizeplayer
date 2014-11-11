class AddDownloadUrlToAssets < ActiveRecord::Migration
  def change
    add_column :assets, :download_url, :string
  end
end
