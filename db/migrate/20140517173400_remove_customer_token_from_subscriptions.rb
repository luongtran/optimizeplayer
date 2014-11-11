class RemoveCustomerTokenFromSubscriptions < ActiveRecord::Migration
  def change
    remove_column :subscriptions, :customer_token
  end
end
