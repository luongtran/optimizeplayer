class ChangeDataTypeForGatewaysFields < ActiveRecord::Migration
  def up
    change_column :gateways, :date, :string
    change_column :gateways, :amount, :string
    change_column :gateways, :postal_code, :string
    change_column :gateways, :tax, :string
  end
  def down
    change_column :gateways, :date, :date
    change_column :gateways, :amount, :float
    change_column :gateways, :postal_code, :integer
    change_column :gateways, :tax, :integer
  end
end
