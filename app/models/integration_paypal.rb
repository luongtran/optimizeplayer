class IntegrationPaypal < Integration
  include PayPal::SDK::REST

  hstore_accessor :api_credentials, %i(client_id client_secret)

  def setup_paypal
    PayPal::SDK.configure({
                            mode: 'sandbox',
                            client_id: client_id,
                            client_secret: client_secret
                          })
  end

  def execute_payment(purchase, payment_id, payer_id)
    setup_paypal

    payment = PayPal::SDK::REST::Payment.find(payment_id)
    
    payment.execute(payer_id: payer_id)

    payload = {type: "paypal", payment_id: payment.id}.merge!(payment.payer.payer_info)

    purchase.payment_info.merge!(payload) {|key, oldval, newval| oldval.present? ? oldval : newval }

    if payment.error
      purchase.payment_info.merge!({errors: payment.error})
      purchase.state = "DECLINE"
    else
      purchase.state = "SALE"
    end

    purchase.save!
    purchase
  end

  def process_purchase(product, callback_url, payment_info)

    payment_key = SecureRandom.hex(16)

    setup_paypal

    purchase = product.purchases.create!(payment_info: payment_info)

    payment = PayPal::SDK::REST::Payment.new({
      intent: "sale",
      payer: {
        payment_method: "paypal" 
      },
      redirect_urls: {
        return_url: "#{callback_url}?payment_key=#{payment_key}&pi_id=#{id}&purchase_id=#{purchase.id}",
        cancel_url: callback_url
      },
      transactions: [ {
        item_list: {
          items: [{
            name: product.title,
            sku: product.product_id,
            price: product.price.to_f,
            currency: "USD",
            quantity: 1 
          }]
        },
        amount: {
          total: product.price.to_f,
          currency: "USD" 
        },
        description: "Purchase from video" } ] } )

    if payment.create
      purchase.payment_info.merge!(payment_id: payment.id)
      purchase.save!

      {
        purchase_id: purchase.id, 
        approval_url: payment.links.select { |l| l.method == "REDIRECT" }.first.href 
      }
    else
      {errors: payment.error}
    end
  end

end
