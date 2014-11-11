class CreateSubscriptions < ActiveRecord::Migration
  def change
    create_table :subscriptions do |t|
      t.integer :user_id
      t.integer :plan_id
      t.string :customer_token
      t.datetime :start
      t.datetime :canceled_at
      t.string :status, default:'disabled'

      t.timestamps
    end
  end
end
