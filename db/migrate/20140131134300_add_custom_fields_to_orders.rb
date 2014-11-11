class AddCustomFieldsToOrders < ActiveRecord::Migration
  def change
    add_column :orders, :custom1, :string
    add_column :orders, :custom2, :string
    add_column :orders, :custom3, :string
    add_column :orders, :custom4, :string
    add_column :orders, :custom5, :string
    add_column :orders, :custom6, :string
    add_column :orders, :custom7, :string
    add_column :orders, :custom8, :string
    add_column :orders, :custom9, :string
    add_column :orders, :custom10, :string
  end
end
