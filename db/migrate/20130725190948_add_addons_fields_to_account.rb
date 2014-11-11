class AddAddonsFieldsToAccount < ActiveRecord::Migration
  def change
    add_column :accounts, :number_of_skins, :integer, default: 0
    add_column :accounts, :number_of_video_imports, :integer, default: 0
    add_column :accounts, :screenshare_support, :integer, default: 0
  end
end
