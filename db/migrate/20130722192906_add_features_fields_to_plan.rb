class AddFeaturesFieldsToPlan < ActiveRecord::Migration
  def change
    add_column :plans, :number_of_embeds, :integer
    add_column :plans, :number_of_users, :integer
    add_column :plans, :has_branding, :boolean
    add_column :plans, :has_ads, :boolean
    add_column :plans, :can_add_cta, :boolean
  end
end
