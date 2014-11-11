class RenameSubscriptionIdToAccountIdForTransaction < ActiveRecord::Migration
  def up
    rename_column :transactions, :subscription_id, :account_id
  end

  def down
    rename_column :transactions, :account_id, :subscription_id
  end
end
