class Account::TransactionsController < AccountController
  before_filter :add_or_update_card, only: [:update_plan, :update_card]

  def update_plan
    current_account.subscription.update_subscription(params[:plan_id])
    redirect_to account_billing_index_path
  end

  def update_card
    redirect_to account_billing_index_path
  end

  private
  def add_or_update_card
    token = params[:stripeToken]
    if token.present?
      customer = current_account.customer
      card = customer.cards.create(card: token)
      current_account.update_attribute(:last4, card.last4)
      customer.default_card = card.id
      customer.save
    end
  end

end
