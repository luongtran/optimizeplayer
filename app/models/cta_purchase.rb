class CtaPurchase < Cta

  attr_accessible :stripe_integration, :paypal_integration
  attr_accessor :stripe_integration, :paypal_integration

  hstore_accessor :options, %i(background_color button_bg_color button_bg_opacity title_color 
                               price_color sub_title title price methods_allowed description 
                               image delivery_method background_color_opacity 
                               stripe_integration_id paypal_integration_id
                               deliver_method product_id download_link ipn_url)

  validates :background_color, :button_bg_color, :title_color, :price_color, rgb: true

  validates :delivery_method, inclusion: {in: %w(link play_video)}, allow_blank: true

  has_many :purchases

  def as_json(options = {})
    super.merge({
      stripe_integration: IntegrationStripe.where(id: stripe_integration_id).first.try(:as_json, {public: options[:include_credentials]}),
      paypal_integration: IntegrationPaypal.where(id: paypal_integration_id).first.try(:as_json, {public: options[:include_credentials]})
    })
  end

  def paypal_integration
    IntegrationPaypal.find(paypal_integration_id)
  end

  def stripe_integration
    IntegrationStripe.find(stripe_integration_id)
  end

end
