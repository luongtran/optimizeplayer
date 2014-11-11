class Account::TeamMembersController < AccountController

  before_filter :find_user, except: [:index, :invite]

  def edit
  end

  def invite
    emails = params[:members].gsub(" ", "").split(",")
    emails.each do |e|
      User.create_team_member(current_account, e)
    end
    redirect_to account_team_path
  end

  def update
    params[:user] ||= {}
    params[:user][:folder_ids] ||= []
    if @user.update_attributes(params[:user])
      redirect_to :back
    end
  end

  def destroy
    @user.destroy
    redirect_to account_team_path
  end

  def show
  end

  private
  def find_user
    @user = current_account.users.find(params[:id])
  end

end