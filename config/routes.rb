Rails.application.routes.draw do
  scope "(:locale)", locale: /#{I18n.available_locales.map(&:to_s).join("|")}/ do
    root to: "home#index"

    resources :login, only: [:index, :create]
    delete "logout" => "login#destroy", as: "logout"

    resources :sign_up, only: [:index, :create]
    resources :confirm_email, only: [:show, :index] do
      collection do
        get "resend" => :resend, as: "resend"
        put "update_email" => :update_email, as: "update_email"
      end
    end

    namespace :settings do
      resource :account, only: [:show, :update, :destroy]
      resource :emails, only: [:show, :update]
      resource :profile, except: :destroy
    end
  end

  namespace :api do
    namespace :v1 do
      resources :users, only: [:index] do
        resources :followings, only: [:index, :create, :destroy], module: :users
        resources :followers, only: [:index], module: :users
      end
    end
  end

  get "/auth/:provider/callback", to: "thirdparty/oauth#callback"
  post "/thirdparty/oauth", to: "thirdparty/oauth#create", as: "thirdparty_oauth"

  require 'sidekiq/web'
  require 'admin_constraint'
  mount Sidekiq::Web => '/sidekiq', :constraints => AdminConstraint.new
end
