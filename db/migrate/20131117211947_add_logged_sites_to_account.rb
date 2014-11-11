class AddLoggedSitesToAccount < ActiveRecord::Migration
  def change
    add_column :accounts, :logged_sites, :text, default: ""
  end
end
