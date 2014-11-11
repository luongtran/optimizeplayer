class AddDownloadJobIdToAsset < ActiveRecord::Migration
  def change
    add_column :assets, :download_job_id, :integer
  end
end
