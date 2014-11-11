class AddSettingsFieldToVideopages < ActiveRecord::Migration
  def change
    add_column :videopages, :settings, :hstore
  end
end
