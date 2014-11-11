class AddFavoriteToProjects < ActiveRecord::Migration
  def change
    add_column :projects, :favorite, :boolean
  end
end
