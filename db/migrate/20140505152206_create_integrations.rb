class CreateIntegrations < ActiveRecord::Migration
  def change
    create_table :integrations do |t|
      t.integer :account_id
      t.string :title
      t.text :api_credentials
      t.string :integration_type
      t.string :provider

      t.timestamps
    end
    add_index :integrations, :account_id
  end
end
