require 'sidekiq/web'
Pixelserve::Application.routes.draw do

  mount_activeadmin_settings

  devise_for :admin_users, ActiveAdmin::Devise.config
  ActiveAdmin.routes(self)

  mount RedactorRails::Engine => '/redactor_rails'
  mount StripeEvent::Engine => '/stripe'

  authenticate :user, lambda { |u| u.admin? } do
    mount Sidekiq::Web => '/sidekiq'
  end

  namespace :api, defaults: {format: 'json'} do
    ######################################################################################################################
    # API V1
    ######################################################################################################################
    namespace :v1 do
      resources :projects do
        member do
          put 'set_position'
          put 'toggle_favorite'
        end
        collection do
          put 'move'
        end
        resources :ctas
      end
      match 'survey_options', to: 'survey_options#create', via: [:post, :options]
      resources :videopages do
        member do
          get 'page'
          put 'save'
          put 'slug_save'
        end
      end
      resources :csns
      resources :assets do
        collection do
          get 'rackspace_url'
          get 'upload_form_params'
        end
        member do
          get 'copy_to_cloudfront'
          get 'start_encoding'
          get 'info_encoding'
          get 'is_finished'
          get 'retry_encoding'
        end
      end
      resources :plans
      resources :folders
      resources :billing do
        collection do
          post '/ipn/:id' => 'billing#ipn'
        end
      end

      resources :integrations do
        collection do
          get 'providers'
          get 'aweber_lists'
          get 'mailchimp_lists'
          get 'getresponse_campaigns'
          get 'csn_directories'
          get 'get_op_hosting_bucket'
          delete 'remove_file'
        end
      end

    end
    ######################################################################################################################
    # API V2
    ######################################################################################################################

    namespace :v2 do
      resources :projects do
        resources :ctas, only: [:index]
      end

      post 'survey_options' => 'survey_options#create'

      # third-party service integrations
      post 'mailchimp_subscribe' => 'mailchimp_integrations#subscribe'

      post 'aweber_subscribe' => 'aweber_integrations#subscribe'

      post 'getresponse_subscribe' => 'getresponse_integrations#subscribe'

      post 'stripe_purchase' => 'stripe_integrations#purchase'

      post 'paypal_purchase' => 'paypal_integrations#purchase'

      get 'paypal_callback' => 'paypal_integrations#callback', defaults: { format: 'html' }

      post 'purchase_callback' => 'purchase_delivery#callback'

    end
  end


  namespace :account do
    root to: 'main#index'

    post 'create_customer' => 'billing#create_customer'

    post 'update_card' => 'transactions#update_card'
    post 'update_plan' => 'transactions#update_plan'
    post 'buy_addon' => 'transactions#buy_addon'

    post 'apply_coupon' => 'subscriptions#apply_coupon'

    get 'team' => 'team_members#index'

    resources :accounts, only: [:update]
    resources :users

    resources :integrations do
      collection do
        get 'aweber_authorize'
        get 'aweber_oauth_callback'
      end
    end

    resources :team_members do
      collection do
        post 'invite'
      end
    end
    resources :billing
    resources :subscriptions do
      member do
        get 'cancel'
      end
    end
  end

  resources :csns, only: [:index] do
    member do
      get 'directories'
    end
  end

  resources :videos

  resources :projects do
    get 'export', on: :collection
    get 'load_player_code'
    member do
      get 'analytics'
    end
  end

  resources :videopages do
    # get 'preview'
  end
  get '/videopage/:id' => 'videopages#edit'

  resources :notifications, only: [:index, :mark_as_read] do
    member do
      put 'mark_as_read'
    end
  end

  resources :accounts

  match '/news/detail' => 'news#detail'
  match 'help' => 'main#help'
  match 'csn_message' => 'main#csn_message'

  # get '/:id' => 'high_voltage/pages#show', :as => :static, :via => :get

  root to: "projects#index"

  post 'hide_welcome' => 'main#hide_welcome'

  devise_for :users, :controllers => {
                                      :registrations => 'registrations',
                                      :passwords => 'devise/passwords'
                                     }

  resources :videopages, :path => ''
  resources :videopages, :path => '', :only => [] do
  end
end
