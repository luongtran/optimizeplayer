class RemoveGatewayFromGateways < ActiveRecord::Migration
  def up
    remove_column :gateways, :gateway
  end

  def down
    add_column :gateways, :gateway, :string
  end
end
