class CreatePlanLists < ActiveRecord::Migration
  def change
    create_table :plan_lists do |t|

      t.timestamps
    end
  end
end
