class CreatePurchases < ActiveRecord::Migration
  def change
    create_table :purchases do |t|
      t.integer :cta_purchase_id
      t.hstore :payment_info

      t.timestamps
    end
  end
end
