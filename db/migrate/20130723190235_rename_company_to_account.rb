class RenameCompanyToAccount < ActiveRecord::Migration
  def self.up
    rename_table :companies, :accounts
    rename_table :companies_guide_tasks, :accounts_guide_tasks
    rename_column :projects, :company_id, :account_id
    rename_column :users, :company_id, :account_id
    rename_column :folders, :company_id, :account_id
    rename_column :encoders, :company_id, :account_id
    rename_column :accounts_guide_tasks, :company_id, :account_id
  end

 def self.down
    rename_table :accounts, :companies
    rename_table :accounts_guide_tasks, :companies_guide_tasks
    rename_column :projects, :account_id, :company_id
    rename_column :users, :account_id, :company_id
    rename_column :folders, :account_id, :company_id
    rename_column :encoders, :account_id, :company_id
    rename_column :companies_guide_tasks, :account_id, :company_id
 end
end
