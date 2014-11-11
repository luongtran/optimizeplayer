class AddDefaultFavoriteValueToProjects < ActiveRecord::Migration
  def change
    change_column :projects, :favorite, :boolean, default: false
  end
end
