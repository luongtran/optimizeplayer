class CreateNotificationsUsers < ActiveRecord::Migration
  def change
    create_table :notifications_users  do |t|
      t.integer :notification_id
      t.integer :user_id
    end
    add_index(:notifications_users, :notification_id)
    add_index(:notifications_users, :user_id)
  end
end
