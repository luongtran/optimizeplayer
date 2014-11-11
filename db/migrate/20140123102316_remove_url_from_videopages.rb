class RemoveUrlFromVideopages < ActiveRecord::Migration
  def up
    remove_column :videopages, :url
  end

  def down
    add_column :videopages, :url, :hstore
  end
end
