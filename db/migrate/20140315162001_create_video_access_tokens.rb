class CreateVideoAccessTokens < ActiveRecord::Migration
  def change
    create_table :video_access_tokens do |t|
      t.string :token
      t.integer :project_id

      t.timestamps
    end
  end
end
