class AddRamountColumnToOrders < ActiveRecord::Migration
  def change
    add_column :orders, :ramount, :float
  end
end
