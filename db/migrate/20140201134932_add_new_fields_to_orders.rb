class AddNewFieldsToOrders < ActiveRecord::Migration
  def change
    add_column :orders, :plan_name, :string
    add_column :orders, :ramount, :string
    add_column :orders, :rfrequency, :string
    add_column :orders, :rfuturepayments, :string
    add_column :orders, :rnextpaymentdate, :string
    add_column :orders, :rstatus, :string
    add_column :orders, :transaction_parent, :string
  end
end
