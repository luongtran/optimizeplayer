class AddOriginalBucketToAssets < ActiveRecord::Migration
  def change
    add_column :assets, :original_bucket, :string
  end
end
