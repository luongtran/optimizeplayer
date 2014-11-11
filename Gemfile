source 'http://rubygems.org'

ruby '2.0.0'

gem 'rails', '3.2.18'
gem 'pg'
gem 'activerecord-postgres-hstore'
gem 'dalli'

gem 'inherited_resources'
gem 'devise', '~> 3.2.2'
gem 'simple_form'

gem 'carrierwave', '~> 0.8.0'
gem 'carrierwave_direct'
gem 'mini_magick', '3.5.0'
gem 'redactor-rails'
gem 'fog'

gem 'aws-sdk', '~> 1.0'
gem 's3_uploader'

gem 'heywatch'
gem 'panda', '~> 1.6.0'

gem 'yettings', git: 'git://github.com/pronix/yettings.git'

gem 'unf'
gem "bugsnag"

gem 'ruby-progressbar'

gem 'capistrano', '~> 2.15'
gem 'capistrano-rails', '~> 1.0.0'
gem 'capistrano-nginx'
gem "capistrano-sidekiq"

gem 'uglifier', '>= 1.0.3'
gem 'haml-rails'
gem 'squeel'

gem 'newrelic_rpm'

gem 'stripe_event'

gem 'acts_as_list'
gem 'activeadmin', github: 'gregbell/active_admin'

gem 'jquery-rails'

gem 'sidekiq'
gem 'sinatra', require: false
gem 'high_voltage'
gem 'cancan'
gem 'gravatar_image_tag'

gem 'whenever'
# integrations

# mailchimp
gem 'gibbon'

# aweber.yml
gem 'aweber'

# getresponse
gem 'getresponse', require:  'get_response'

# stripe
gem 'stripe'

# paypal
gem 'paypal-sdk-rest'

gem 'activeadmin-settings', github: 'slate-studio/activeadmin-settings'

gem 'postmark-rails', '~> 0.7.0'

#for copying to clipboard
gem 'zeroclipboard-rails'

group :assets do
  gem 'sass-rails',   '~> 3.2.5'
  gem 'coffee-rails', '~> 3.2.1'
  gem 'therubyracer', :platforms => :ruby
  gem 'compass', '~> 0.12.0'
  gem 'compass-rails', '~> 1.0.3'
  gem 'compass-colors'
  gem 'sassy-buttons'
  gem 'turbo-sprockets-rails3'
  gem 'zurb-foundation', '~> 4.0.0'
  gem 'sugar-rails'
end

group :development, :test do
  gem 'teaspoon'
  gem 'guard-teaspoon'
  gem 'guard-rspec'
end

group :test do
  gem 'rspec-rails', '~> 2.0'
  gem 'factory_girl_rails'
  gem 'capybara'
  gem 'shoulda'
  gem 'database_cleaner'
  gem 'faker'
  gem 'launchy'
  gem 'vcr'
  gem 'webmock'
  gem 'selenium-webdriver'
end

group :staging, :development do
  gem 'better_errors'
end

group :staging do
  gem 'unicorn'
  gem 'unicorn-worker-killer'
end

group :development do
  gem 'binding_of_caller'
  gem 'rails3-generators'
  gem 'thin'
  gem 'quiet_assets'
  gem 'pry-rails'
  gem 'debugger'
  gem 'yaml_db'
end

