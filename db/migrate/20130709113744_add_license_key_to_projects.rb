class AddLicenseKeyToProjects < ActiveRecord::Migration
  def change
    add_column :projects, :license_key, :string
  end
end
