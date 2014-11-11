class IntegrationAmazons3 < IntegrationCsn
  hstore_accessor :api_credentials, %i(bucket access_key_id secret_access_key cloudfront use_cloudfront)
  validate :csn_credentials_are_valid

  after_save do
    if use_cloudfront
      storage_service.create_distribution
    end
    storage_service.apply_cors_rules
  end

  def as_json(options={})
    super.merge({bucket: bucket})
  end
end
