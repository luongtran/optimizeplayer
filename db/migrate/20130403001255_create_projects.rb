class CreateProjects < ActiveRecord::Migration
  def change 
    create_table :projects do |t|
      t.references :company
      t.string :title
      t.string :file
      t.boolean :file_processing
      t.hstore :flowplayer
      t.string :allowed_urls
      t.string :tags
      t.string :analytics

      t.timestamps
    end
    add_index :projects, :company_id
  end
end
