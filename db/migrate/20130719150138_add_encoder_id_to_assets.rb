class AddEncoderIdToAssets < ActiveRecord::Migration
  def change
    add_column :assets, :encoder_id, :integer
  end
end
