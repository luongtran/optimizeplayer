#Create default plans
unless ENV['minimal']
  Plan.delete_all
  PlanList.delete_all

  pl = PlanList.create

  # create default plans

  Plan.create(
    interval: 'month',
    number_of_embeds: -1,
    number_of_jobs: -1,
    file_size_limit: 1024,
    number_of_users: 1,
    has_branding: true,
    has_ads: true,
    can_add_cta: true,
    can_encode: true,
    can_analytics: true,
    can_host: true,
    bandwidth: 2048,
    name: 'Gratis',
    amount: 0,
    remote_id: 'gratis',
    currency: 'usd',
    plan_type: 'free',
    position: 1,
    private: FALSE
  )

  Plan.create(
    interval: 'month',
    number_of_embeds: -1,
    can_encode: true,
    number_of_jobs: 1,
    file_size_limit: 1024,
    number_of_users: 1,
    has_branding: true,
    has_ads: true,
    can_add_cta: true,
    can_analytics: true,
    can_host: false,
    name: 'Self Host',
    amount: 900,
    remote_id: 'selfhost',
    currency: 'usd',
    plan_type: 'recurring',
    position: 3,
    private: FALSE
  )

  Plan.create(
    interval: 'month',
    name: 'Entrepreneur',
    number_of_embeds: -1,
    can_encode: true,
    number_of_jobs: -1,
    file_size_limit: 1024,
    number_of_users: 3,
    has_branding: false,
    has_ads: false,
    can_add_cta: true,
    can_analytics: true,
    can_host: true,
    bandwidth: 256000,
    amount: 2900,
    remote_id: 'entrepreneur',
    currency: 'usd',
    plan_type: 'recurring',
    position: 6,
    trial_period_days: 30,
    private: FALSE
  )

  Plan.create(
    interval: 'month',
    name: 'Start Up',
    number_of_embeds: -1,
    number_of_users: 10,
    can_encode: true,
    number_of_jobs: -1,
    file_size_limit: 1024,
    has_branding: false,
    has_ads: false,
    can_add_cta: true,
    can_analytics: true,
    can_host: true,
    bandwidth: 1024000,
    amount: 4900,
    remote_id: 'startup',
    currency: 'usd',
    plan_type: 'recurring',
    position: 9,
    trial_period_days: 30,
    private: FALSE
  )

  # create default gateways for ClickBank, JVZoo, DealGuardian, Generic
  Gateway.create(
    name: 'ClickBank',
    key: 'SECRET',
    date: 'ctranstime',
    transaction_code: 'ctransreceipt',
    user_name: 'ccustfullname',
    email: 'ccustemail',
    amount: 'corderamount',
    affiliate: 'ctransaffiliate',
    payment_method: 'ctranspaymentmethod',
    address_1: 'ccustaddr1',
    address_2: 'ccustaddr20',
    city: 'ccustcity',
    state: 'ccuststate',
    postal_code: 'ccustzip',
    country_name: 'ccustcc',
    transaction_type: 'ctransaction',
    currency: 'ccurrency',
    charge_type: 'cprodtype',
    tracking_id: 'ctid',
    tax: 'ctaxamount',
    plan_id: 'cproditem',
    ramount: 'crebillamnt',
    rfrequency: 'crebillfrequency',
    rfuturepayments: 'cfuturepayments',
    rnextpaymentdate: 'cnextpaymentdate',
    rstatus: 'crebillstatus',
    transaction_parent: 'cupsellreceipt',
    custom1: 'cprodtitle'
  )

  Gateway.create(
    name: 'JVZoo',
    date: 'ctranstime',
    transaction_code: 'ctransreceipt',
    user_name: 'ccustname',
    email: 'ccustemail',
    amount: 'ctransamount',
    affiliate: 'ctransaffiliate',
    payment_method: 'ctranspaymentmethod',
    state: 'ccuststate',
    country_name: 'ccustcc',
    transaction_type: 'ctransaction',
    charge_type: 'cprodtype',
    tracking_id: 'caffitid',
    plan_id: 'cproditem',
    transaction_parent: 'cupsellreceipt',
    custom1: 'cprodtitle',
    custom2: 'cvendthru',
    custom3: 'cverify'
  )

  Gateway.create(
    name: 'DealGuardian',
    key: 'secret_key',
    date: 'transaction_date',
    transaction_code: 'transaction_id',
    user_name: 'buyer_first_name',
    email: 'buyer_email',
    amount: 'transaction_amount',
    affiliate: 'transaction_affiliate',
    transaction_type: 'transaction_type',
    plan_id: 'product_id',
    transaction_parent: 'transaction_parent_id',
    custom1: 'product_name',
    custom2: 'transaction_jv',
    custom3: 'transaction_subscription_id',
    custom4: 'transaction_subscription_pay_number'
  )

  Gateway.create(
    name: 'Generic',
    date: 'transaction_date',
    transaction_code: 'payment_id',
    user_name: 'customer_fullname',
    email: 'email',
    amount: 'product_price',
    payment_method: 'type',
    postal_code: 'billing_zipcode',
    transaction_type: 'transaction_type',
    plan_id: 'product_id',
    custom1: 'payer_id',
    custom2: 'product_title',
    custom3: 'token_url'
  )

  # create default transaction mappings
  TransactionMapping.create(
    action: 'create_account',
    value: 'SALE,TEST,TEST_SALE'
  )

  TransactionMapping.create(
    action: 'suspend_account',
    value: 'CGBK'
  )

  TransactionMapping.create(
    action: 'account_overdue',
    value: 'RFND'
  )

  # create company csn
  company_csn = IntegrationAmazons3.new(
    title: "OptimizePlayer",
    api_credentials: {"access_key_id"=>"AKIAJWDPNEZ6R5KHD26A","bucket"=>"ophosting","secret_access_key"=>"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"},
    integration_type: "company_csn",
    provider: "amazons3"
  )
  company_csn.save(validate:false)
end
