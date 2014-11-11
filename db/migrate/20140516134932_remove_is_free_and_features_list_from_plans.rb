class RemoveIsFreeAndFeaturesListFromPlans < ActiveRecord::Migration
  def change
    remove_column :plans, :is_free
    remove_column :plans, :features_list
  end
end
