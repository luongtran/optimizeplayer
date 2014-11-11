class AddEncodedFilenameAndResultFilenameToAssets < ActiveRecord::Migration
  def change
    add_column :assets, :encoded_filename, :string
    add_column :assets, :result_filename, :string
  end
end
