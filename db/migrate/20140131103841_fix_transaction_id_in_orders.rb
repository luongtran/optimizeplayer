class FixTransactionIdInOrders < ActiveRecord::Migration
  def change
    rename_column :orders, :transaction_id, :transaction_code
  end
end
