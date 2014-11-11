class AddEmbedCssToProject < ActiveRecord::Migration
  def change
    add_column :projects, :embed_css, :text
  end
end
