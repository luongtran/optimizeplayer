ActiveAdmin.register Account, as: "Accounts" do
  menu :priority => 2

  PLANS = [{:name => 'Gratis', :remote_id => 'gratis'}, {:name => 'Self Host', :remote_id => 'selfhost'}, {:name => 'Entrepreneur', :remote_id => 'entrepreneur'}, {:name => 'Start Up', :remote_id => 'startup'}]

  scope :all, :default => true

  PLANS.each do |plan|
    scope plan[:name] do |accounts|
      p = Plan.find_by_remote_id(plan[:remote_id])
      if p.present?
        accounts.joins(:subscription).where(['subscriptions.plan_id = ?', p[:id]])
      end
    end
  end

  index do
    column :name
    column :users do |acc|
      "#{acc.users.count}/#{acc.plan.try(:number_of_users)}"
    end
    column :projects do |acc|
      acc.projects.count
    end
    column :plan do |acc|
      acc.plan.try(:name)
    end
    actions
  end

  show do |acc|
    attributes_table do
      row :name
      row :users do
        acc.users.count
      end
      row :number_of_jobs
      row :customer_id
      row :logged_sites
      table_for acc.users do
        column "Users" do |user|
          link_to user.email, admin_customer_path(user)
        end
      end
    end
  end

end
