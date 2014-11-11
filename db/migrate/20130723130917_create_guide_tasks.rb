class CreateGuideTasks < ActiveRecord::Migration
  def change
    create_table :guide_tasks do |t|
      t.string :title
      t.text :short_description

      t.timestamps
    end
  end
end
