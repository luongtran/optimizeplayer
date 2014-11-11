class AccountController < BaseController
  before_filter :check_ownership!

  def check_ownership!
    redirect_to account_root_path unless current_user.owner
  end

end
