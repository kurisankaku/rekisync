Rails.application.routes.draw do
  resources :login, only: [:index, :create]
  resources :sign_up, only: [:index, :create]
end
