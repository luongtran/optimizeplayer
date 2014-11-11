ActiveAdmin.register TransactionMapping do
  menu :priority => 9

  index do
    column :action
    column :value
    actions
  end

  form do |f|
    f.inputs do
      f.input :action
      f.input :value
    end
    f.actions
  end
end
