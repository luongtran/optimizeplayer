require "bundler/capistrano"
require "capistrano/nginx/tasks"
require 'capistrano/sidekiq'

load "deploy/assets"
 
# ==============================================================
# SET"s
# ==============================================================

#noinspection RubyResolve
default_run_options[:pty] = true
set :repository,  "git@github.com:bizlaunchequity/optimizeplayer.git"

server "162.243.74.189", :web, :app, :single_instance

set :scm, "git"
set :branch, "new_design"

set :user, "root"
set :domain, "162.243.74.189"
set :application, "pixelserve"
set :server_name, "162.243.74.189"
 
set :use_sudo, false 
set :sudo_user, "root"

ssh_options[:forward_agent] = true

set :deploy_to, "/var/www/apps/pixelserve" 
set :git_shallow_clone, 1

set :scm_verbose, true
set :copy_cache, true 
set :keep_releases, 5 
 
set :rails_env, :staging

set :unicorn_conf, "#{deploy_to}/current/config/unicorn.rb"
set :unicorn_pid, "#{deploy_to}/shared/pids/unicorn.pid"

task :custom_bundle_install, roles: :app do
    run "cd #{deploy_to}/releases/#{release_name} && NOKOGIRI_USE_SYSTEM_LIBRARIES=1 bundle install --gemfile #{deploy_to}/releases/#{release_name}/Gemfile --path #{deploy_to}/shared/bundle --deployment --quiet --without development test"
  end
before "bundle:install", "custom_bundle_install"

before "deploy:assets:precompile" do
  run "ln -nfs #{deploy_to}/shared/config/database.yml #{release_path}/config/database.yml"
  run "ln -nfs #{deploy_to}/shared/config/stripe.rb #{release_path}/config/initializers/stripe.rb"
end

after "deploy:restart", "deploy:cleanup"

namespace :deploy do
  task :restart do
    run "if [ -f #{unicorn_pid} ] && [ -e /proc/$(cat #{unicorn_pid}) ]; then kill -USR2 `cat #{unicorn_pid}`; else cd #{deploy_to}/current && bundle exec unicorn_rails -c #{unicorn_conf} -E #{rails_env} -D; fi"
  end
  task :start do
    run "bundle exec unicorn_rails -c #{unicorn_conf} -E #{rails_env} -D"
  end
  task :stop do
    run "if [ -f #{unicorn_pid} ] && [ -e /proc/$(cat #{unicorn_pid}) ]; then kill -QUIT `cat #{unicorn_pid}`; fi"
  end
end
