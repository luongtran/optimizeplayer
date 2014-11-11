class AddKeyFieldToGateways < ActiveRecord::Migration
  def change
    add_column :gateways, :key, :string
  end
end
