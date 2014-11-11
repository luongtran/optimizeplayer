class AddNumberOfJobsToPlan < ActiveRecord::Migration
  def change
    add_column :plans, :number_of_jobs, :integer, default: 0
  end
end
