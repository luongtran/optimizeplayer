class AddOverdueFieldToUsers < ActiveRecord::Migration
  def change
    add_column :users, :overdue_notify, :integer
  end
end
