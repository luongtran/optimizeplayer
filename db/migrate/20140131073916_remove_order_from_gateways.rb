class RemoveOrderFromGateways < ActiveRecord::Migration
  def up
    remove_column :gateways, :order
  end

  def down
    add_column :gateways, :order, :string
  end
end
