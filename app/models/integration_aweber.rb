class IntegrationAweber < Integration
  hstore_accessor :api_credentials, %i(access_token access_token_secret)

  def lists
    oauth = AWeber::OAuth.new(AWEBER_CONFIG['consumer_key'], AWEBER_CONFIG['consumer_secret'])
    oauth.authorize_with_access(access_token, access_token_secret)
    api = AWeber::Base.new(oauth)
    lists = []
    api.account.lists.each do |l|
      lists.push({:id => l[0], :name => l[1].name})
    end
    return lists
  end
end
