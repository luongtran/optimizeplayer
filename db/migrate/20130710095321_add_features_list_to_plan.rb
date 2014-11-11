class AddFeaturesListToPlan < ActiveRecord::Migration
  def change
    add_column :plans, :features_list, :text
  end
end
