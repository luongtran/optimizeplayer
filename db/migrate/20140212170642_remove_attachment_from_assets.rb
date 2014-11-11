class RemoveAttachmentFromAssets < ActiveRecord::Migration
  def change
    remove_column :assets, :attachment
  end
end
