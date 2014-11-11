class AddLast4ToAccount < ActiveRecord::Migration
  def change
    add_column :accounts, :last4, :string
  end
end
