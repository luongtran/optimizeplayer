# Read about factories at https://github.com/thoughtbot/factory_girl

FactoryGirl.define do
  factory :transaction_mapping do
    action 'create_account'
    value 'SALE,TEST,TEST_SALE'
  end
end
