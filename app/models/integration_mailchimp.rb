class IntegrationMailchimp < Integration
  hstore_accessor :api_credentials, %i(api_key)
  attr_accessible :api_key

  def lists
    api = Gibbon::API.new(api_key)
    lists = []
    api.lists.list['data'].each do |l|
      lists.push({:id => l['id'], :name => l['name']})
    end
    return lists
  end
end
