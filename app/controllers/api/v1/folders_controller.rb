module Api
  module V1

    class FoldersController < Api::V1::BaseController
      respond_to :json
      inherit_resources

      def index
        @folders = current_user.folders.where(parent_id: nil).includes(:subfolders)
        respond_with @folders # subfolders included by Folder#as_json
      end

      def show
        response.headers["Cache-Control"] = "no-cache, no-store, max-age=0, must-revalidate"
        response.headers["Pragma"] = "no-cache"
        response.headers["Expires"] = "Fri, 01 Jan 1990 00:00:00 GMT"
        respond_with resource
      end

      def begin_of_association_chain
        current_user.account
      end
    end

  end
end