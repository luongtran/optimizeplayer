module Api
  module V2
    class GetresponseIntegrationsController < Api::V2::BaseController

      def subscribe
        cta = CtaOptin.find(params[:cta_id])
        if cta.integration.present?
          getresponse = IntegrationGetresponse.find(cta.integration.id);
          begin
            api = GetResponse::Connection.new(getresponse.secret_api_key)
            api.contacts.create('email' => params[:email], 'campaign' => cta.list_id)
            render nothing: true
          rescue Exception => e
            render json: e.message
          end
        end
      end
    end
  end
end