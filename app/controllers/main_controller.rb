class MainController < BaseController
  respond_to :html

  skip_before_filter :authenticate_user!, only: [:home]
  skip_before_filter :check_user_suspend, only: [:home]

  def home
    if !current_user
      redirect_to new_user_session_path
    end
  end

  def help
  end

  def hide_welcome
    session[:hide_welcome] = true
    render nothing: true
  end

end
