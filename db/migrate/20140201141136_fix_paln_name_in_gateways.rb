class FixPalnNameInGateways < ActiveRecord::Migration
  def change
    rename_column :gateways, :plan_name, :plan_id
  end
end
