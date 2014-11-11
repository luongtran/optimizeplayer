class CreateExtensionHstore < ActiveRecord::Migration
  execute "CREATE EXTENSION hstore"
end