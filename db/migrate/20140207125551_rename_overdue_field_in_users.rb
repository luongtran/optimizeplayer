class RenameOverdueFieldInUsers < ActiveRecord::Migration
  def change
		rename_column :users, :active, :suspend
  end
end
