class AddFolderIdToProjects < ActiveRecord::Migration
  def change
    add_column :projects, :folder_id, :integer
  end
end
