module Api
  module V1
    class IntegrationsController < Api::V1::BaseController
      inherit_resources

      def index
        if (params[:integration_type].present? && params[:integration_type] == 'company_csn')
          integrations = Integration.where(integration_type: params[:integration_type])
        else
          integrations = current_account.integrations
          integrations = integrations.select { |i| i.integration_type == params[:integration_type] } if params[:integration_type].present?
          integrations = integrations.select { |i| i.provider == params[:provider] } if params[:provider].present?
        end
        render json: integrations
      end

      def show
        integration = Integration.find(params[:id]).as_json(include_credentials: true) 
        render json: integration
      end

      def create
        integration = Integration.create_of_type(current_account.id, params[:integration])

        begin
          if integration.save
            render json: integration
          else
            render text: integration.errors.full_messages.join("<br/>"), status: :error
          end
        rescue
          render text: integration.errors.full_messages.join("<br/>"), status: :error
        end
      end

      def update
        integration = current_account.integrations.find(params[:id])
        integration.update_attributes(params[:integration])
        render nothing: true, status: :ok
      end

      def destroy
        Integration.destroy(params[:id])
        render nothing: true, status: 204
      end

      def providers
        render json: Integration::PROVIDERS
      end

      def mailchimp_lists
        integration = IntegrationMailchimp.find(params[:id])
        if integration.present?
          render json: integration.lists
        else
          render nothing: false
        end
      end

      def aweber_lists
        integration = IntegrationAweber.find(params[:id])
        if integration.present?
          render json: integration.lists
        else
          render nothing: false
        end
      end

      def getresponse_campaigns
        integration = IntegrationGetresponse.find(params[:id])
        if integration.present?
          render json: integration.campaigns
        else
          render nothing: false
        end
      end

      def csn_directories
        integration = Integration.get_of_type(params)
        if integration.present?
          if params[:bucket]
            render json: {csn_id: params[:id], folder: current_user.security_salt, directories: integration.directory_tree(params[:bucket])}
          else
            render json: {csn_id: params[:id], folder: current_user.security_salt, directories: integration.directories}
          end
        else
          render nothing: false
        end
      end

      def get_op_hosting_bucket
        op_integration = Integration.where(integration_type: "company_csn").first
        if op_integration.present?
          render json: op_integration.bucket
        end
      end

      def remove_file
        @integration = Integration.where(integration_type: "company_csn").first
        if @integration.present?
          credentials = { provider: "AWS",
                          aws_access_key_id: @integration.access_key_id,
                          aws_secret_access_key: @integration.secret_access_key }
          @connection = Fog::Storage.new(credentials)
          @connection.delete_object(params[:bucket], params[:file_key])
          render json: true
        else
          render nothing: false
        end
      end
    end
  end
end
