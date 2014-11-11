class ChangeGatewayColumnNameInOrders < ActiveRecord::Migration
  def change
    rename_column :orders, :gateway, :gateway_id
  end
end
