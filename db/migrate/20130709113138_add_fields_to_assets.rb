class AddFieldsToAssets < ActiveRecord::Migration
  def change
    add_column :assets, :key, :string
    add_column :assets, :csn_id, :integer
    add_column :assets, :project_id, :integer
    add_column :assets, :url, :string
    add_column :assets, :format, :string
    add_column :assets, :active, :boolean
    add_column :assets, :media_type, :string
    add_column :assets, :file_origin, :string
  end
end
