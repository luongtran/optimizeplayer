module Api
  module V2
    class AweberIntegrationsController < Api::V2::BaseController

      def subscribe
        cta = CtaOptin.find(params[:cta_id])
        if cta.integration.present?
          aweber = IntegrationAweber.find(cta.integration.id);
          begin
            oauth = AWeber::OAuth.new(AWEBER_CONFIG['consumer_key'], AWEBER_CONFIG['consumer_secret'])
            oauth.authorize_with_access(aweber.access_token, aweber.access_token_secret)
            api = AWeber::Base.new(oauth)
            # new subscriber
            api.account.lists[cta.list_id.to_i].subscribers.create('email' => params[:email])
            render nothing: true
          rescue Exception => e
            error_message = e.message
            error_message.slice!('email: ')
            render json: error_message
          end
        end
      end
    end
  end
end