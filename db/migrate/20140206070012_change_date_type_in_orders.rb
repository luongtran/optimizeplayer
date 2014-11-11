class ChangeDateTypeInOrders < ActiveRecord::Migration
  def change
    change_column :orders, :date, :datetime
  end
end
