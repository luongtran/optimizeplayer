class Plan < ActiveRecord::Base

  FEATURES = [:number_of_embeds, :number_of_users, :has_branding, :has_ads, :can_add_cta, :number_of_jobs, :can_encode, :can_host, :bandwidth]

  attr_accessible :amount, :interval, :name, :remote_id,
                  :currency, :position, :plan_list_id, :trial_period_days, :file_size_limit, :private, :plan_type, *FEATURES, :can_analytics

  has_many :subscriptions
  has_many :orders
  belongs_to :plan_list
  acts_as_list scope: :plan_list

  before_create :create_plan
  before_update :update_plan
  before_destroy :delete_plan

  validates :remote_id, uniqueness: true
  validates :amount, :plan_type, presence: true

  acts_pricefully :amount

  def features
    unless self.can_host == true
      features = FEATURES.select {|feature| feature != :bandwidth}
    else
      features = Array.new(FEATURES)
    end

    features.collect do |feature|
      if Plan.columns_hash[feature.to_s].type == :boolean
        I18n.t "#{feature}.#{self.send(feature) ? 'has' : 'hasnt'}"
      elsif Plan.columns_hash[feature.to_s].type == :integer
        if self.send(feature) == -1
          I18n.t "#{feature}.unlimited"
        else
          I18n.t feature, count: self.send(feature)
        end
      end
    end
  end

  def raw_features_list

  end

  #FIXME need more reliable way to store and retrieve such data
  def embeds_count
    number_of_embeds
  end

  def free?
    amount == 0
  end
  private

  def create_plan
    begin
      Stripe::Plan.create(
        :amount => self.amount,
        :interval => self.interval,
        :name => self.name,
        :currency => "usd",
        :id => self.remote_id,
        :trial_period_days => self.trial_period_days)
    rescue
    end

  end

  def update_plan
    monitored_fields = %w(amount interval currency)
    case self.plan_type
      when 'recurring'
        unless (self.changed & monitored_fields).empty?
          Stripe::Plan.retrieve(self.remote_id).delete
          s_plan = Stripe::Plan.create(:amount => self.amount,
                                       :interval => self.interval,
                                       :name => self.name,
                                       :currency => "usd",
                                       :id => self.remote_id)
          self.remote_id = s_plan.id
        end
      when 'free'
        self.amount = 0
        self.interval = ''
      when 'one-time'
        self.interval = ''
    end
  end

  def delete_plan
    stripe_plan.delete
  end

  def stripe_plan
   @stripe_plan ||= Stripe::Plan.retrieve(remote_id)
  end

end
