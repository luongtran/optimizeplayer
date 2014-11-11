require 'csv'

class ProjectsController < BaseController
  load_and_authorize_resource find_by: :cid, except: [:show, :new, :create]

  respond_to :html, :js, :json
  respond_to :csv, only: [:export]

  before_filter :find_project, only: [:edit, :destroy, :update, :set_position, :analytics]

  skip_filter :authenticate_user!, only: [:show]
  skip_filter :check_subdomain, only: [:show]

  def index
    @search = params[:search]
    respond_to do |format|
      format.html
      format.json { render json: current_account.projects }
    end
  end

  # DEPRECATED
  def export
    csv = CSV.generate do |csv|
      csv << ['Project title', 'Embed code']
      ids = params[:ids]
      ids = ids.values unless ids.is_a?(Array) # if ids is a hash
      Project.where(id: ids).each do |project|
        csv << [project.title, "<script src='#{request.base_url}/projects/#{project.cid}'></script>"]
      end
    end

    respond_to do |format|
      format.csv { send_data csv, type: Mime::CSV, disposition: "attachment; filename=projects-#{Date.today.to_s}.csv" }
    end
  end

  def new
    @csns = current_account.csns
  end

  def show
    @project = Project.find_by_cid(params[:id])
    @referer = request.referer.present? ? URI(request.referer) : nil

    token = @referer ? Rack::Utils.parse_nested_query(@referer.query)["video_token"] : "" #FIXME

    @project.url = nil unless @project.allow_play? || @project.allowed_token?(token)

    if !@project.allowed_urls.present? || @project.allowed_urls.index(@referer.try(:host))

      # No idea what this code does, needs to be understood and refactored
      # url_segments = @project.url.split('/', 5)

      # unless url_segments.empty?
      #   bucket = url_segments[3]
      #   path = url_segments[4]
      #   csn = Csn.where(:account_id => @project.account_id).where(:bucket => bucket).first

      #   if csn.present?
      #     if csn.use_cloudfront?
      #       @project.url = "https://#{csn.cloudfront}/#{path}"
      #     end
      #   end
      # end

      render :show, layout: 'embed'
    else
      render nothing: true, status: 403
    end
  end

  def edit
  end

  def analytics
  end

  def create
    project = current_account.projects.create(params[:project])

    if project.save
      render json: project, status: :ok
    else
      render nothing: true, status: :error
    end
  end

  def update
    if @project.update_attributes(params[:project])
      render json: @project, status: :ok
    else
      render nothing: true, status: :error
    end
  end

  def destroy
    @project.destroy
    redirect_to :back
  end

  def set_position
    if params[:position]
      @project.set_list_position(params[:position].to_i)
    end

    respond_with @project
  end

  private
  def find_project
    @project = current_account.projects.find_by_cid(params[:id])
  end
end
