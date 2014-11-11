class ChangeFieldsAtNotifications < ActiveRecord::Migration
  def change
    rename_column :notifications, :body, :description

    add_column :notifications, :notification_type, :string
    add_column :notifications, :url, :string
  end
end
