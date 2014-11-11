FactoryGirl.define do
  factory :user do
    name 'Example User'
    email Faker::Internet.email
    password 'changeme'
    password_confirmation 'changeme'
    url Faker::Internet.domain_word
    suspend nil
    # required if the Devise Confirmable module is used
    # confirmed_at Time.now
  end

  factory :user_for_embededs, class: 'User' do
    name 'Ebededs Test User'
    email 'ebededs_example@example.com'
    password 'changeme2'
    password_confirmation 'changeme2'
    # required if the Devise Confirmable module is used
    # confirmed_at Time.now
  end
end
