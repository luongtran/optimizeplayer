class AddLoggedSitesToProject < ActiveRecord::Migration
  def change
    add_column :projects, :logged_sites, :text, default: ""
  end
end
