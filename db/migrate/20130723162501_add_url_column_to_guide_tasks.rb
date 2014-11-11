class AddUrlColumnToGuideTasks < ActiveRecord::Migration
  def change
    add_column :guide_tasks, :url, :string
  end
end
