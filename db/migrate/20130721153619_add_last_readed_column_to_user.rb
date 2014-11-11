class AddLastReadedColumnToUser < ActiveRecord::Migration
  def change
    add_column :users, :last_readed_post, :datetime
  end
end
