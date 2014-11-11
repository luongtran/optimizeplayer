class AddPlanIdToOrders < ActiveRecord::Migration
  def change
    add_column :orders, :plan_id, :string
  end
end
