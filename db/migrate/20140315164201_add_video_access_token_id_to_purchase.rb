class AddVideoAccessTokenIdToPurchase < ActiveRecord::Migration
  def change
    add_column :purchases, :video_access_token_id, :integer
  end
end
