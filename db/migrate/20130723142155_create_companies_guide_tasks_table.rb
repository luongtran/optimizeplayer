class CreateCompaniesGuideTasksTable < ActiveRecord::Migration
  def self.up

    create_table :companies_guide_tasks do |t|
      t.integer :company_id
      t.integer :guide_task_id
    end
  end

  def down
    drop_table :companies_guide_tasks
  end
end
