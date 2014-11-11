class FixTransactionIdInGateways < ActiveRecord::Migration
  def change
    rename_column :gateways, :transaction_id, :transaction_code
  end
end
