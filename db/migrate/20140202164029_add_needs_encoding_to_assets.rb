class AddNeedsEncodingToAssets < ActiveRecord::Migration
  def change
    add_column :assets, :needs_encoding, :bool
  end
end
