Rails.application.routes.draw do
  scope "(:locale)", locale: /#{I18n.available_locales.map(&:to_s).join("|")}/ do
    resources :login, only: [:index, :create]
    resources :sign_up, only: [:index, :create]
  end
end
