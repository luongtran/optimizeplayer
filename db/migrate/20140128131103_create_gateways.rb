class CreateGateways < ActiveRecord::Migration
  def change
    create_table :gateways do |t|
      t.string :order
      t.string :transaction_id
      t.float :amount
      t.string :transaction_type

      t.timestamps
    end
  end
end
