ActiveAdmin.register Notification do
  menu :priority => 6

  index do
    column :id
    column :title
    column :notification_type
    column :url
    column :created_at
    column :updated_at
    actions
  end

  form do |f|
    f.inputs do
      f.input :title
      f.input :description, input_html: { class: 'redactor', :rows => 40, :cols => 120 }
      f.input :notification_type, as: :select, collection: ["News", "Bug", "Feature"]
      f.input :url
    end
    f.actions
  end
end
