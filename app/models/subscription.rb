class Subscription < ActiveRecord::Base
  attr_accessible  :plan, :plan_id, :account, :start, :status

  belongs_to :account
  belongs_to :plan

  validates :account_id, :plan_id, presence: true

  def trialing?
    status == 'trialing' && plan.plan_type == 'free'
  end

  def unpaid?
    status == 'unpaid'
  end

  def cancel_subscription
    account.customer.cancel_subscription
  end

  def retrieve_subscription
    return account.customer.subscription
  end

  def update_subscription(plan_id)
    plan = Plan.find_by_id(plan_id)
    unless plan.blank?
      case plan.plan_type
        when 'recurring'
          if account.customer.update_subscription(plan: plan.remote_id)
            update_attribute(:plan, plan)
          end
        when 'one-time'
          charge = Stripe::Charge.create(
            :amount => plan.amount,
            :currency => 'usd',
            :customer => account.customer_id
          )
          if charge.blank? && charge.captured
            update_attribute(:plan, plan)
          end
        when 'free'
          update_attribute(:plan, plan)
      end
    end
  end

  def downgradable?
    account.projects.count < plan.number_of_embeds && account.users.count <= plan.number_of_users
  end
end
