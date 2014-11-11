class RemoveStripeKeysFromAccount < ActiveRecord::Migration
  def up
    remove_column :accounts, :stripe_key
    remove_column :accounts, :stripe_public_key
  end

  def down
  end
end
