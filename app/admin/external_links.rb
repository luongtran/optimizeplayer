ActiveAdmin.register ExternalLink do
  menu :priority => 6

  index do
    column :id
    column :image do |el|
      image_tag(el.image.url(:thumb))
    end
    column :title
    column :url
    column :active
    column :updated_at
    actions
  end

  form :html => {:enctype => "multipart/form-data"} do |f|
    f.inputs do
      f.input :title
      f.input :url
      f.input :active
      f.input :image, :as => :file, :hint => f.object.image.present? \
        ? f.template.image_tag(f.object.image.url())
        : f.template.content_tag(:span, "no image yet")
      f.input :image_cache, :as => :hidden
    end

    f.actions
  end

end
