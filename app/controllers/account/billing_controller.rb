class Account::BillingController < AccountController

  respond_to :html

  def index
    @subscription = current_account.subscription
    @current_plan = @subscription.try :plan
    @plans = Plan.order('position ASC').where('private <> TRUE')
    @external_links = ExternalLink.find_all_by_active(true)
  end

end
