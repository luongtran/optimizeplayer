class CreateTransactionMappings < ActiveRecord::Migration
  def change
    create_table :transaction_mappings do |t|
      t.string :action
      t.string :value

      t.timestamps
    end
  end
end
