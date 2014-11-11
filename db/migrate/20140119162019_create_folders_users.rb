class CreateFoldersUsers < ActiveRecord::Migration
  def change
    create_table :folders_users  do |t|
      t.integer :folder_id
      t.integer :user_id
    end
    add_index(:folders_users, :folder_id)
    add_index(:folders_users, :user_id)
  end
end
