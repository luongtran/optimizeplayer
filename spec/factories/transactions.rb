# Read about factories at https://github.com/thoughtbot/factory_girl

FactoryGirl.define do
  factory :transaction do
    subscription_id 1
    description "MyString"
  end
end
