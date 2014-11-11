class Account::SubscriptionsController < AccountController
  
  def cancel
    current_account.subscription.cancel_subscription
  end

  def apply_coupon
    coupon_id = params[:coupon]
    customer = current_account.customer
    customer.coupon = coupon_id
    customer.save
    redirect_to account_billing_index_path
  end
end
