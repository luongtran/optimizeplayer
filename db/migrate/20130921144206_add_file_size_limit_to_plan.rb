class AddFileSizeLimitToPlan < ActiveRecord::Migration
  def change
    add_column :plans, :file_size_limit, :integer
  end
end
