Rails.application.routes.draw do
  scope "(:locale)", locale: /#{I18n.available_locales.map(&:to_s).join("|")}/ do
    root to: "home#index"

    resources :login, only: [:index, :create]
    delete "logout" => "login#destroy", as: "logout"

    resources :sign_up, only: [:index, :create] do
      collection do
        get "confirm_email/:token" => :confirm_email, as: "confirm_email"
      end
    end

    namespace :settings do
      resource :account, only: [:show, :update, :destroy]
      resource :emails, only: [:show, :update]
    end
  end

  get "/auth/twitter/callback", to: "thirdparty/oauth#callback_twitter"

  require 'sidekiq/web'
  require 'admin_constraint'
  mount Sidekiq::Web => '/sidekiq', :constraints => AdminConstraint.new
end
