class AddPlanIdToGateways < ActiveRecord::Migration
  def change
    add_column :gateways, :plan_id, :string
  end
end
