class Account::IntegrationsController < AccountController

  def index
  end

  def new
    @integration = current_account.integrations.new
  end

  def edit
    @integration = current_account.integrations.find(params[:id])
  end

  def create
    @integration = Integration.new_of_type(current_account.id, params[:integration])

    if @integration.save
      redirect_to account_integrations_path
    else
      redirect_to :back
    end
  end

  def update
    @integration = current_account.integrations.find(params[:id])
    if @integration.update_attributes!(params[:integration])
      redirect_to :back
    end
  end

  def aweber_oauth_callback
    if params[:oauth_verifier].present?
      oAuth = AWeber::OAuth.new(AWEBER_CONFIG['consumer_key'], AWEBER_CONFIG['consumer_secret'])
      oAuth.request_token = OAuth::RequestToken.from_hash(oAuth.consumer, {:oauth_token => params[:oauth_token], :oauth_token_secret => session[:oauth_token_secret]})
      oAuth.authorize_with_verifier(params[:oauth_verifier])
      @access_token = {:access_token => oAuth.access_token.token, :access_token_secret => oAuth.access_token.secret}
    end
    render layout: false
  end

  def aweber_authorize
    oAuth = AWeber::OAuth.new(AWEBER_CONFIG['consumer_key'], AWEBER_CONFIG['consumer_secret'])
    callback_url = URI.join(root_url, aweber_oauth_callback_account_integrations_path())
    request_token = oAuth.request_token(:oauth_callback => callback_url)
    session[:oauth_token_secret] = request_token.secret
    redirect_to request_token.authorize_url
  end
end
