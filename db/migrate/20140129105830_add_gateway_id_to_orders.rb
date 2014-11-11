class AddGatewayIdToOrders < ActiveRecord::Migration
  def change
	  add_column :orders, :gateway_id, :integer
  end
end
