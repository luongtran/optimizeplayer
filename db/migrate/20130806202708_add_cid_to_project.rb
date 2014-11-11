class AddCidToProject < ActiveRecord::Migration
  def change
    add_column :projects, :cid, :string
  end
end
