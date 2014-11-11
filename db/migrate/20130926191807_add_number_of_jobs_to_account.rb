class AddNumberOfJobsToAccount < ActiveRecord::Migration
  def change
    add_column :accounts, :number_of_jobs, :integer, default: 0
  end
end
