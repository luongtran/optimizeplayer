module Api
  module V2
    class StripeIntegrationsController < Api::V2::BaseController

      def purchase
        cta = CtaPurchase.find(params[:cta_id])
        payment_integration = cta.stripe_integration

        purchase = payment_integration.process_purchase(cta, params[:stripe_token], params[:payment_info])

        if purchase.payment_info["errors"].present?
          render json: {errors: purchase.payment_info["errors"]}, status: :not_acceptable
        else
          render json: {purchase_id: purchase.id}, status: :ok
        end
      end

    end
  end
end
