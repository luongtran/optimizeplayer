ActiveAdmin.register Plan do
  menu :priority => 9

  index do
    column :name
    column :remote_id
    column :bandwidth
    column :number_of_users
    column :plan_type
    column :interval
    column :amount
    column :position
    column :private
    actions
  end

  form do |f|
    f.inputs do
      f.input :name
      f.input :remote_id
      f.input :number_of_embeds
      f.input :number_of_users
      f.input :number_of_jobs
      f.input :has_branding
      f.input :has_ads
      f.input :can_add_cta
      f.input :can_encode
      f.input :can_host
      f.input :can_analytics
      f.input :file_size_limit
      f.input :bandwidth
      f.input :plan_type, as: :select, collection: ['free', 'recurring', 'one-time']
      f.input :interval, as: :select, collection: ['month', 'week', 'year']
      f.input :trial_period_days
      f.input :amount
      f.input :position
      f.input :private
    end
    f.actions
  end
end
