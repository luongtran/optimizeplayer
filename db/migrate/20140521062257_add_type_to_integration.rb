class AddTypeToIntegration < ActiveRecord::Migration
  def change
    add_column :integrations, :type, :string
  end
end
