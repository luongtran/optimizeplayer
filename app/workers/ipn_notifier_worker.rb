class IpnNotifierWorker
  include Sidekiq::Worker
  sidekiq_options retry: 5

  sidekiq_retry_in do |count|
    1.hour
  end

  def perform(purchase_id)
    purchase = Purchase.find(purchase_id)
    product = purchase.cta_purchase

    payload = { 
                customer_fullname: purchase.fullname,
                product_title:     product.title,
                product_id:        product.product_id,
                product_price:     product.price.to_f*100,
                transaction_type:  purchase.state,
                transaction_date:  purchase.created_at.to_s,
                token_url:         purchase.video_access_token.try(:token) || product.download_link,
                errors:            purchase.payment_info["errors"]
              }.merge(purchase.payment_info)

    RestClient.post(product.ipn_url, payload){  |response, request, result, &block|
      case response.code
      when 200
        Sidekiq.logger.info "Successfully posted Purchase##{purchase_id} info: #{payload} to #{product.ipn_url}"
      else
        message = "Failed to post Purchase##{purchase_id} info: #{payload} to #{product.ipn_url}, status #{response.code}"
        output = [message, response.to_s, result.inspect].join(" ")
        Sidekiq.logger.warn output
        raise output
      end
    }
  end
end