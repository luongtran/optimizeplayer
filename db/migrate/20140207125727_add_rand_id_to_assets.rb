class AddRandIdToAssets < ActiveRecord::Migration
  def change
    add_column :assets, :rand_id, :integer
  end
end
