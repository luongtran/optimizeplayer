class Api::V2::BaseController < ApplicationController
  def current_session
    request.headers["X-User-Session"]
  end
  helper_method :current_session
  
end