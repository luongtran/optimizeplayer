class AddBandwidthToPlans < ActiveRecord::Migration
  def change
    add_column :plans, :bandwidth, :integer
  end
end
