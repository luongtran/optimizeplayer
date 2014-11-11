class VideopagesController < BaseController
  respond_to :html, :js, :json
  before_filter :find_project, :only => [:edit]
  skip_filter :authenticate_user!, only: [:show]

  skip_before_filter :check_subdomain, only: [:show]
  skip_before_filter :check_user_suspend, only: [:show]

  def edit
    unless @project.blank?
      if @project.videopage.blank?
        @project.build_videopage
        @project.save
      end
    else
      not_found
    end

  end

  def show
    unless current_subdomain.blank? and params[:id].blank?
      user = User.find_by_url(current_subdomain)
      unless user.blank?
        videopage = user.videopages.where(:user_id=>user.id).where(:slug=>params[:id]).first

        unless videopage.blank?
          parse_params = ['widgets', 'seo']
          parse_params.each do |parse_param|
            videopage[parse_param] = parse_json(videopage[parse_param])
          end

          @preview_page = videopage
          render :action => "show", :layout => "video_preview"
        else
          not_found
        end

      else
        not_found
      end
    else
      render :action => "show", :layout => "video_preview"
    end
  end

  private
  def find_project
    @project = current_account.projects.find_by_cid(params[:id])
  end

  def not_found
    respond_to do |format|
      format.html { render :file => "#{Rails.root}/public/404", :layout => false, :status => :not_found }
      format.xml  { head :not_found }
      format.any  { head :not_found }
    end
  end

  def parse_json(data)
    unless data.blank?
      ActiveSupport::JSON.decode(data)
    end
  end
end