class IntegrationRackspace < IntegrationCsn
  hstore_accessor :api_credentials, %i(bucket username api_key rs_temp_url_key rs_endpoint_url rs_endpoint_path rs_streaming_url rs_public_url)
  validate :csn_credentials_are_valid

  before_save do
    storage = storage_service
    storage.apply_cors_rules
    self.rs_temp_url_key  = storage.connection.head_containers.headers['X-Account-Meta-Temp-Url-Key']
    self.rs_streaming_url = storage.bucket.streaming_url
    self.rs_public_url    = storage.bucket.public_url
    endpoint_uri          = storage.connection.endpoint_uri
    self.rs_endpoint_url  = endpoint_uri.to_s
    self.rs_endpoint_path = endpoint_uri.path
  end

  def as_json(options={})
    super.merge({bucket: bucket})
  end
end
