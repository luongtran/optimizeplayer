class AddEncodingJobIdToAssets < ActiveRecord::Migration
  def change
    add_column :assets, :encoding_job_id, :string
  end
end
