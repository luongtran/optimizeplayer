# Read about factories at https://github.com/thoughtbot/factory_girl

FactoryGirl.define do
  factory :gratis_plan, class: 'Plan' do
    interval 'month'
    name 'Gratis'
    number_of_embeds -1
    number_of_jobs -1
    file_size_limit 1024
    number_of_users 1
    has_branding true
    has_ads true
    can_add_cta true
    can_encode true
    can_analytics true
    can_host true
    bandwidth 2048
    amount 0
    remote_id 'gratis'
    currency 'usd'
    plan_type 'free'
    position 1
    private false
  end
end
