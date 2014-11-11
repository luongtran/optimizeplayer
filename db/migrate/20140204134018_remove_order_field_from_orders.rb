class RemoveOrderFieldFromOrders < ActiveRecord::Migration
  def change
    remove_column :orders, :order
  end
end
