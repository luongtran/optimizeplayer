module Api
  module V2
    class PaypalIntegrationsController < Api::V2::BaseController

      def purchase
        cta = CtaPurchase.find(params[:cta_id])
        result = cta.paypal_integration.process_purchase(cta, api_v2_paypal_callback_url, params[:payment_info])

        if result[:errors]
          render json: result, status: :not_acceptable
        else
          render json: result, status: :ok
        end
      end

      def callback
        request.format = "js"

        pi = IntegrationPaypal.find(params[:pi_id])
        purchase = Purchase.find(params[:purchase_id])
        payment_id = purchase.payment_info["payment_id"]
        pi.execute_payment(purchase, payment_id, params[:PayerID])

        render layout: false
      end
    
    end
  end
end
