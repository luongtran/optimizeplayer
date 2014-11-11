class AddPlanListIdToPlan < ActiveRecord::Migration
  def change
    add_column :plans, :plan_list_id, :integer
  end
end
