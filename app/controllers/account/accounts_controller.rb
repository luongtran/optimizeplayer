class Account::AccountsController < AccountController

  def update

    if current_account.update_attributes(params[:account])
      redirect_to account_root_path
    else
      flash[:danger] = current_account.errors.full_messages.join(", ")
      redirect_to account_root_path
    end

  end

end