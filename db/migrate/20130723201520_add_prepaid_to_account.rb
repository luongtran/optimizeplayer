class AddPrepaidToAccount < ActiveRecord::Migration
  def change
    add_column :accounts, :prepaid, :boolean, default: false
  end
end
