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
  end

  require 'sidekiq/web'
  require 'admin_constraint'
  mount Sidekiq::Web => '/sidekiq', :constraints => AdminConstraint.new
end
