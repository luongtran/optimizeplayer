class AddCanEncodeToPlans < ActiveRecord::Migration
  def change
    add_column :plans, :can_encode, :boolean
  end
end
