FactoryGirl.define do
  factory :integration_mailchimp do
    account_id FactoryGirl.create(:account).id
    title 'Mailchimp ' + Faker::Number.number(3)
    integration_type 'email'
    provider 'mailchimp'
    type 'IntegrationMailchimp'
    api_key '26c9f6969491f655ab910d829f5613f0-us1'
  end

  factory :integration_aweber do
    account_id FactoryGirl.create(:account).id
    title 'Aweber ' + Faker::Number.number(3)
    integration_type 'email'
    provider 'aweber'
    type 'IntegrationAweber'
    access_token 'AgyhDxNGjDNr7h4nM82gEjuZ'
    access_token_secret '9hfXnlhdLgy9BQjdbFVVLqCTWNemuAmGF0heICXx'
  end

  factory :integration_getresponse do
    account_id FactoryGirl.create(:account).id
    title 'Getresponse ' + Faker::Number.number(3)
    integration_type 'email'
    provider 'getresponse'
    type 'IntegrationGetresponse'
    secret_api_key 'f0184a94323d786c9ae69379fef1c19c'
  end

  factory :integration_amazons3 do
    account_id FactoryGirl.create(:account).id
    title 'Amazon S3 ' + Faker::Number.number(3)
    integration_type 'csn'
    provider 'amazons3'
    type 'IntegrationAmazons3'
    access_key_id 'AKIAJJNC4SXZU5LIB33A'
    secret_access_key 'iik4WJ+kxneVNvorPCF+ewUQ+qmWQsuZzmpTI0Z3'
    bucket 'xingjin'
    use_cloudfront false
    cloudfront 'dcohiu8tsncjd.cloudfront.net'
  end

  factory :integration_rackspace do
    account_id FactoryGirl.create(:account).id
    title 'Rackspace ' + Faker::Number.number(3)
    integration_type 'csn'
    provider 'rackspace'
    type 'IntegrationRackspace'
    username 'xing.jin'
    api_key '72cdb19782784c1abe3a1d70ea5768f5'
    bucket 'xingjin'
  end
end
