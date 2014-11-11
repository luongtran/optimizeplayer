class ChangeRamountTypeInOrders < ActiveRecord::Migration
  def change
    remove_column :orders, :ramount
  end
end
