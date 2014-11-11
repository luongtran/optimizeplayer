class CreateTransactions < ActiveRecord::Migration
  def change
    create_table :transactions do |t|
      t.integer :subscription_id
      t.string :description

      t.timestamps
    end
  end
end
