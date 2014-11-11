class AddNewFieldsToGateways < ActiveRecord::Migration
  def change
    add_column :gateways, :ramount, :string
    add_column :gateways, :rfrequency, :string
    add_column :gateways, :rfuturepayments, :string
    add_column :gateways, :rnextpaymentdate, :string
    add_column :gateways, :rstatus, :string
    add_column :gateways, :transaction_parent, :string
  end
end
