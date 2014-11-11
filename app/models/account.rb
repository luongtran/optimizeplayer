class Account < ActiveRecord::Base
  has_many :users
  has_many :csns, :class_name => 'Integration'
  has_many :projects
  has_many :folders
  has_many :transactions
  has_many :integrations

  has_one :subscription

  attr_accessible :name

  after_create do
    self.folders.create(name: 'uncategorized')
  end

  def plan
    self.subscription.try(:plan)
  end

  def create_customer
    customer = Stripe::Customer.create(:email => self.users.find_by_owner(true).email)
    self.update_attribute(:customer_id, customer.id)

    plan = Plan.find_by_plan_type('free')
    self.create_subscription(plan)
  end

  def create_customer_with_plan(plan)
    customer = Stripe::Customer.create(
      :plan => plan,
      :email => self.users.find_by_owner(true).email
    )
    self.update_attribute(:customer_id, customer.id)

    plan = Plan.find_by_remote_id(plan)
    self.create_subscription(plan)
  end

  def create_subscription(plan)
    unless subscription.present?
      self.subscription = Subscription.create!(plan: plan, account: self, status: "trialing", start: Date.today)
    end
  end

  def create_charge(amount)
    charge = Stripe::Charge.create(
      :amount => amount * 100,
      :currency => 'usd',
      :card => Account.customer.default_card
    )
  end

  def customer
    Stripe::Customer.retrieve(self.customer_id)
  end

  def has_credit_card?
    self.last4.present?
  end

  def plan?(plan_name)
    self.subscription.plan.name.to_sym.eql?(plan_name)
  end
end
