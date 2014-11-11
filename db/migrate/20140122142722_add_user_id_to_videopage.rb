class AddUserIdToVideopage < ActiveRecord::Migration
  def change
    add_column :videopages, :user_id, :integer
  end
end
