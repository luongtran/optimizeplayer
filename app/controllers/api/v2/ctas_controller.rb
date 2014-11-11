module Api
  module V2
    class CtasController < Api::V2::BaseController

      def index
        project = Project.find_by_cid(params[:project_id])
        render json: project.ctas(current_session)
      end

    end
  end
end