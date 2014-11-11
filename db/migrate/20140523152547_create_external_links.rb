class CreateExternalLinks < ActiveRecord::Migration
  def change
    create_table :external_links do |t|
      t.string :title
      t.integer :price
      t.string :url
      t.boolean :active
      t.timestamps
    end
  end
end
