class AddPositionToPlan < ActiveRecord::Migration
  def change
    add_column :plans, :position, :integer
  end
end
