class IntegrationStripe < Integration
  hstore_accessor :api_credentials, %i(publishable_key secret_key)

  def as_json(options={})
    super.merge(publishable_key: publishable_key)
  end

  def setup_stripe
    Stripe.api_key = secret_key
  end

  def process_purchase(product, token, payment_info={})
    setup_stripe
    purchase_info = payment_info

    begin
      charge = Stripe::Charge.create(
        amount: (product.price.to_f*100).to_i,
        currency: "usd",
        card: token,
        description: "[##{product.product_id}] #{product.title} #{product.description}"
      )
      purchase_info.merge!({type: "stripe", payment_id: charge.id})
    rescue => e
      purchase_info.merge!({errors: e.message, type: "stripe"})
    end
    
    create_purchase(product, purchase_info)
  end

  def create_purchase(product, options)
    purchase = product.purchases.new
    if options[:errors]
      purchase.payment_info = {errors: options[:errors]}.merge(options)
      purchase.state = "DECLINE"
    else
      purchase.payment_info = options 
      purchase.state = "SALE"
    end
    purchase.save!
    purchase
  end

end
