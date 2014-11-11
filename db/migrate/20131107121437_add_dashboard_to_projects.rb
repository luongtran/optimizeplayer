class AddDashboardToProjects < ActiveRecord::Migration
  def change
    add_column :projects, :dashboard, :bool
  end
end
