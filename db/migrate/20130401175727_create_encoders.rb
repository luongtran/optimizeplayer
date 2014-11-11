class CreateEncoders < ActiveRecord::Migration
  def change
    create_table :encoders do |t|
      t.references :company
      t.string :provider
      t.string :access_key
      t.string :secret_key
      t.boolean :active

      t.timestamps
    end
    add_index :encoders, :company_id
  end
end
