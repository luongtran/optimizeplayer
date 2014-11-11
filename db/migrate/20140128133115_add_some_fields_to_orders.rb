class AddSomeFieldsToOrders < ActiveRecord::Migration
  def change
    add_column :orders, :date, :date
    add_column :orders, :order, :string
    add_column :orders, :transaction_id, :string
    add_column :orders, :email, :string
    add_column :orders, :phone, :string
    add_column :orders, :gateway, :string
    add_column :orders, :amount, :float
    add_column :orders, :affiliate, :string
    add_column :orders, :payment_method, :string
    add_column :orders, :address_1, :string
    add_column :orders, :address_2, :string
    add_column :orders, :city, :string
    add_column :orders, :state, :string
    add_column :orders, :postal_code, :integer
    add_column :orders, :country, :string
    add_column :orders, :transaction_type, :string
    add_column :orders, :currency, :string
    add_column :orders, :charge_type, :string
    add_column :orders, :tracking_id, :string
    add_column :orders, :tax, :integer
  end
end
