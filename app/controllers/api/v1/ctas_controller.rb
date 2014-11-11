module Api
  module V1
    class CtasController < Api::V1::BaseController
      respond_to :html, :js, :json
      respond_to :csv, only: [:export]

      before_filter :find_project

      def create
        attrs = params[:cta].except(:cid, :flat_cuepoints)
        cta = @project.create_cta(attrs)
        render json: cta.as_json(include_credentials: true), status: :ok
      end

      def update
        cta = Cta.find_by_id(params[:id])
        if cta.update_attributes(params[:cta].except(:cid, :id, :flat_cuepoints, :provider))
          render json: cta.as_json(include_credentials: true)
        else
          render json: {errors: cta.errors.full_messages}, status: 422
        end
      end

      def destroy
        cta = Cta.find_by_id(params[:id])
        if cta.destroy
          cta.project.save!
          render nothing: true, status: :ok
        end
      end

      private
      def find_project
        @project = Project.find_by_cid(params[:project_id])
      end
    end
  end
end