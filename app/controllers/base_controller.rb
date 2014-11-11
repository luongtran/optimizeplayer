class BaseController < ApplicationController
  before_filter :authenticate_user!

  before_filter :check_user_suspend
  before_filter :check_subdomain

  layout Proc.new { |controller| controller.request.xhr? ? false : 'application' }

  helper_method :current_account

  def after_sign_in_path_for(user)
    root_url(subdomain: false)
  end

  def after_sign_out_path_for(resource_or_scope)
    root_url(subdomain: false)
  end

  def current_account
    current_user.account
  end

  def current_subdomain
    request.subdomain(2)
  end

  def check_subdomain
    if current_user and !current_user.url.blank?
      if current_subdomain != current_user.url
        redirect_to root_url(subdomain: current_user.url)
      end
    else
      unless current_subdomain.blank?
        redirect_to root_url(subdomain: false)
      end
    end
  end

  def check_user_suspend
    if current_user and !current_user.suspend.blank?
      sign_out
    end
  end
end