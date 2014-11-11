class CreatePlans < ActiveRecord::Migration
  def change
    create_table :plans do |t|
      t.string :interval
      t.string :name
      t.integer :amount
      t.string :remote_id
      t.string :currency

      t.timestamps
    end
  end
end
