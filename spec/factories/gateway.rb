# Read about factories at https://github.com/thoughtbot/factory_girl

FactoryGirl.define do
  factory :gateway do
    name 'ClickBank'
    key 'SECRET'
    date 'ctranstime'
    transaction_code 'ctransreceipt'
    user_name 'ccustfullname'
    email 'ccustemail'
    amount 'corderamount'
    affiliate 'ctransaffiliate'
    payment_method 'ctranspaymentmethod'
    address_1 'ccustaddr1'
    address_2 'ccustaddr20'
    city 'ccustcity'
    state 'ccuststate'
    postal_code 'ccustzip'
    country_name 'ccustcc'
    transaction_type 'ctransaction'
    currency 'ccurrency'
    charge_type 'cprodtype'
    tracking_id 'ctid'
    tax 'ctaxamount'
    plan_id 'cproditem'
    ramount 'crebillamnt'
    rfrequency 'crebillfrequency'
    rfuturepayments 'cfuturepayments'
    rnextpaymentdate 'cnextpaymentdate'
    rstatus 'crebillstatus'
    transaction_parent 'cupsellreceipt'
    custom1 'cprodtitle'
  end
end
