class AddCustomFieldsToGateways < ActiveRecord::Migration
  def change
    add_column :gateways, :custom1, :string
    add_column :gateways, :custom2, :string
    add_column :gateways, :custom3, :string
    add_column :gateways, :custom4, :string
    add_column :gateways, :custom5, :string
    add_column :gateways, :custom6, :string
    add_column :gateways, :custom7, :string
    add_column :gateways, :custom8, :string
    add_column :gateways, :custom9, :string
    add_column :gateways, :custom10, :string
  end
end
