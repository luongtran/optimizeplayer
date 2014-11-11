class AddNameToEncoders < ActiveRecord::Migration
  def change
    add_column :encoders, :name, :string
  end
end
