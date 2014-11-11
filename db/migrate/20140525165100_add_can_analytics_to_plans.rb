class AddCanAnalyticsToPlans < ActiveRecord::Migration
  def change
    add_column :plans, :can_analytics, :boolean
  end
end
