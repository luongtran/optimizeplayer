class Account::UsersController < AccountController

  skip_before_filter :check_ownership!, only: [:update]

  def update

    @user = current_user
    user_params = params[:user]
    user_params.delete(:email)
    successfully_updated = if needs_password?(@user, params)
      @user.update_with_password(user_params)
    else
      # remove the virtual current_password attribute update_without_password
      # doesn't know how to ignore it
      attrs = user_params
      attrs.delete("current_password")
      @user.update_without_password(attrs)
    end
    if successfully_updated
      # Sign in the user bypassing validation in case his password changed
      sign_in @user, :bypass => true
      #redirect_to account_root_path
      respond_to do |format|
        format.js
      end
    else
      flash[:danger] = @user.errors.full_messages.join(", ")
      respond_to do |format|
        format.js
      end
    end

  end

  private
  # check if we need password to update user data
  # ie if password or email was changed
  # extend this as needed
  def needs_password?(user, params)
    (user.email != params[:user][:email] && params[:user][:email]) ||
      !user.encrypted_password.present? && params[:user][:password].blank? ||
      params[:user][:password].present?
  end

end