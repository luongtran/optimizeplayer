class RemovePriceFromExternalLinks < ActiveRecord::Migration
  def change
    remove_column :external_links, :price
  end
end
