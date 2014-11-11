class Account::MainController < AccountController
  respond_to :html

  skip_before_filter :check_ownership!, only: [:index]

  def index
  end

end
