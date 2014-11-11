class ChangeAmountsTypesInOrders < ActiveRecord::Migration
  def change
    change_column :orders, :tax, :float
  end
end
