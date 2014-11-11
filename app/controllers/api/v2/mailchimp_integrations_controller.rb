module Api
  module V2
    class MailchimpIntegrationsController < Api::V2::BaseController

      def subscribe
        cta = CtaOptin.find(params[:cta_id])
        if cta.integration.present?
          mailchimp = IntegrationMailchimp.find(cta.integration.id);
          begin
            api = Gibbon::API.new(mailchimp.api_key)
            api.lists.subscribe({:id => cta.list_id, :email => {:email => params[:email]}})
            render nothing: true
          rescue Exception => e
            render json: e.message
          end
        end
      end
    end
  end
end