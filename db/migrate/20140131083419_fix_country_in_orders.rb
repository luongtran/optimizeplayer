class FixCountryInOrders < ActiveRecord::Migration
  def change
    rename_column :orders, :country, :country_name
  end
end
