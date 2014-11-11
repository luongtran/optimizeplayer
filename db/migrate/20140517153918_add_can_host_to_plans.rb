class AddCanHostToPlans < ActiveRecord::Migration
  def change
    add_column :plans, :can_host, :boolean
  end
end
