class AddResponderCodeToProject < ActiveRecord::Migration
  def change
    add_column :projects, :responder_code, :text
  end
end
