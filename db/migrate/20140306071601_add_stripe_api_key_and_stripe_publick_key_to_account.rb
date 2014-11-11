class AddStripeApiKeyAndStripePublickKeyToAccount < ActiveRecord::Migration
  def change
    add_column :accounts, :stripe_key, :string
    add_column :accounts, :stripe_public_key, :string
  end
end
