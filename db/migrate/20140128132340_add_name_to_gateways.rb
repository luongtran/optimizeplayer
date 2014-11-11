class AddNameToGateways < ActiveRecord::Migration
  def change
    add_column :gateways, :name, :string
  end
end
