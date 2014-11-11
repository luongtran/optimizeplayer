class AddSlugToVideopage < ActiveRecord::Migration
  def change
    add_column :videopages, :slug, :text
  end
end
