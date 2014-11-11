class CreateVideopages < ActiveRecord::Migration
  def change
    create_table :videopages do |t|
      t.integer :project_id
      t.hstore :url
      t.hstore :template
      t.text :widgets
      t.text :seo
      t.boolean :is_iframe

      t.timestamps
    end
  end
end
