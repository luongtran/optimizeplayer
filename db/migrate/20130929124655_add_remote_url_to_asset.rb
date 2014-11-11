class AddRemoteUrlToAsset < ActiveRecord::Migration
  def change
    add_column :assets, :remote_url, :string
  end
end
