class RemoveFormatFromAssets < ActiveRecord::Migration
  def change
    remove_column :assets, :format
  end
end
