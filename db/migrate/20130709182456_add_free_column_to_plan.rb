class AddFreeColumnToPlan < ActiveRecord::Migration
  def change
    add_column :plans, :is_free, :boolean, default: false
  end
end
