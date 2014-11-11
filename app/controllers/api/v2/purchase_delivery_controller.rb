module Api
  module V2
    class PurchaseDeliveryController < Api::V2::BaseController

      def callback
        purchase = Purchase.find(params[:purchase_id])
        case purchase.delivery_method
          when 'link'
            render json: {type: 'link', link: purchase.cta_purchase.download_link}, status: :ok
          when 'play_video'
            render json: {type: 'play_video', link: purchase.cta_purchase.project.url}, status: :ok
          else
            render nothing: true, status: :ok
        end
      end

    end
  end
end