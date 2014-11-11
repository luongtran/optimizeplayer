class RenamePostsTableToNotifications < ActiveRecord::Migration
  def change
    rename_table :posts, :notifications
  end
end
