class AddDefaultValueToDashboardInProjects < ActiveRecord::Migration
  def change
    change_column :projects, :dashboard, :boolean, default: false
  end
end
