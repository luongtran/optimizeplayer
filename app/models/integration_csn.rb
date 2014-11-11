class IntegrationCsn < Integration
  attr_accessor :storage_service

  def directories
    storage_service.get_buckets_list
  end

  def directory_tree(name)
    storage_service.get_bucket_tree(name)
  end

  def storage_service
    storage =  case provider
      when 'amazons3'
        AwsStorage.new(self)
      when 'rackspace'
        RackspaceStorage.new(self)
    end
    storage
  end

  def csn_credentials_are_valid
    begin
      self.storage_service
    rescue Excon::Errors::Forbidden
      errors.add(:base, "Credentials are invalid")
    rescue Excon::Errors::Unauthorized
      errors.add(:base, "Credentials are invalid")
    end
  end
end
