class RegistrationsController < Devise::RegistrationsController

  def new
    render template: "devise/registrations/new", layout: "sign_up"
  end

  def create
    build_resource(sign_up_params)
    if resource.save!
      unless params[:plan_remote_id].blank?
        plan = Plan.find_by_remote_id(params[:plan_remote_id])
        unless plan.blank?
          resource.account.create_customer_with_plan(params[:plan_remote_id])
        else
          resource.account.create_customer
        end
      else
        resource.account.create_customer
      end
      if resource.active_for_authentication?
        set_flash_message :notice, :signed_up if is_navigational_format?
        sign_up(resource_name, resource)
        respond_with resource, :location => after_sign_up_path_for(resource)
      else
        set_flash_message :notice, :"signed_up_but_#{resource.inactive_message}" if is_navigational_format?
        expire_session_data_after_sign_in!
        respond_with resource, :location => after_inactive_sign_up_path_for(resource)
      end
    else
      clean_up_passwords resource
      render template: "devise/registrations/new", layout: "sign_up"
    end
  end
end
