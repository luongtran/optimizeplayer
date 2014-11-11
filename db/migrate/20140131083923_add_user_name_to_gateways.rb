class AddUserNameToGateways < ActiveRecord::Migration
  def change
    add_column :gateways, :user_name, :string
  end
end
