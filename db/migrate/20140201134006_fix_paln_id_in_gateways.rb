class FixPalnIdInGateways < ActiveRecord::Migration
  def change
    rename_column :gateways, :plan_id, :plan_name
  end
end
