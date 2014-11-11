class AddPrivateToPlans < ActiveRecord::Migration
  def change
    add_column :plans, :private, :boolean
  end
end
