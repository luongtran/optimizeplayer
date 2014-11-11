class IntegrationGetresponse < Integration
  hstore_accessor :api_credentials, %i(secret_api_key)

  def campaigns
    api = GetResponse::Connection.new(secret_api_key)
    campaigns = []
    api.campaigns.all.each do |c|
      campaigns.push({:id => c.id, :name => c.name})
    end
    return campaigns
  end
end
