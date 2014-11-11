module Api
  module V1
    class UploadsController < Api::V1::BaseController
      before_filter :authenticate_user!

      def my_uploads
        @assets = current_user.assets
      end

    end
  end
end
