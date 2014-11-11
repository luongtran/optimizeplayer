class AddIntegrationIdToCta < ActiveRecord::Migration
  def change
    add_column :cta, :integration_id, :integer
  end
end
