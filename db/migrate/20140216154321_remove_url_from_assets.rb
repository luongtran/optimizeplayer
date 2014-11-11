class RemoveUrlFromAssets < ActiveRecord::Migration
  def change
    remove_column :assets, :url
  end
end
