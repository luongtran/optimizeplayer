class FixCountryInGateways < ActiveRecord::Migration
  def change
    rename_column :gateways, :country, :country_name
  end
end
