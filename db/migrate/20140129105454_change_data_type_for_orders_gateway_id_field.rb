class ChangeDataTypeForOrdersGatewayIdField < ActiveRecord::Migration
  def change
	  remove_column :orders, :gateway_id
  end
end
