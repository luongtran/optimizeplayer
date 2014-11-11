class AddUnavailableToAssets < ActiveRecord::Migration
  def change
    add_column :assets, :unavailable, :boolean
  end
end
