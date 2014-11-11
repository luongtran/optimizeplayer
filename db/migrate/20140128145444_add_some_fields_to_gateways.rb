class AddSomeFieldsToGateways < ActiveRecord::Migration
  def change
    add_column :gateways, :date, :date
    add_column :gateways, :email, :string
    add_column :gateways, :phone, :string
    add_column :gateways, :gateway, :string
    add_column :gateways, :affiliate, :string
    add_column :gateways, :payment_method, :string
    add_column :gateways, :address_1, :string
    add_column :gateways, :address_2, :string
    add_column :gateways, :city, :string
    add_column :gateways, :state, :string
    add_column :gateways, :postal_code, :integer
    add_column :gateways, :country, :string
    add_column :gateways, :currency, :string
    add_column :gateways, :charge_type, :string
    add_column :gateways, :tracking_id, :string
    add_column :gateways, :tax, :integer
  end
end
