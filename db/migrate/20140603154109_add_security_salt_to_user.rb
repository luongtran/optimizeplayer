class AddSecuritySaltToUser < ActiveRecord::Migration
  def change
    add_column :users, :security_salt, :string
  end
end
