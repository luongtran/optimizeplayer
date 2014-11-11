class Integration < ActiveRecord::Base

  PROVIDERS = [
      { label: 'Stripe',           provider: 'stripe',      integration_type: 'payment'     },
      { label: 'Paypal',           provider: 'paypal',      integration_type: 'payment'     },
      { label: 'MailChimp',        provider: 'mailchimp',   integration_type: 'email'       },
      { label: 'Aweber',           provider: 'aweber',      integration_type: 'email'       },
      { label: 'Get Response',     provider: 'getresponse', integration_type: 'email'       },
      { label: 'Amazon S3',        provider: 'amazons3',    integration_type: 'csn'         },
      { label: 'Rackspace',        provider: 'rackspace',   integration_type: 'csn'         },
      { label: 'Optimize Hosting', provider: 'amazons3',    integration_type: 'company_csn' }
    ].deep_freeze

  attr_accessible :account_id, :api_credentials, :provider, :title, :integration_type

  validates :integration_type, :provider, :api_credentials, :account_id, :title, presence: true

  validates :provider, presence: true, inclusion: { in: PROVIDERS.map {|i| i[:provider] } }

  before_validation :set_integration_type

  class << self

    def from_provider(provider_name)
      PROVIDERS.find { |p| p[:provider] == provider_name }
    end

    def new_of_type(account_id, attrs)
      class_from_type(attrs[:provider]).new(attrs.merge(account_id: account_id))
    end

    def create_of_type(account_id, attrs)
      class_from_type(attrs[:provider]).new(attrs.merge(account_id: account_id))
    end

    def get_of_type(attrs)
      class_from_type(attrs[:provider]).find(attrs[:id])
    end

  end

  def as_json(options={})
    json = {
      id: id,
      title: title,
      provider: provider,
      integration_type: integration_type
    }
    json.merge!(api_credentials: api_credentials) if options[:include_credentials]
    json
  end

  def label
    Integration.from_provider(provider)[:label]
  end

  def is_company_csn
    return integration_type == 'company_csn'
  end

  private
  def set_integration_type
    self.integration_type = Integration.from_provider(self.provider)[:integration_type] if self.integration_type.blank?
  end

  def self.class_from_type(type)
    "Integration#{type.capitalize}".constantize
  end

end
