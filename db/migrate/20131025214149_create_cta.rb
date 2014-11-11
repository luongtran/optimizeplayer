class CreateCta < ActiveRecord::Migration
  def change
    create_table :cta do |t|
      t.text :html
      t.integer :project_id
      t.hstore :options
      t.string :type

      t.timestamps
    end
  end
end
