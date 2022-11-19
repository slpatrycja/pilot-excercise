Rails.application.routes.draw do
  root 'payment_requests#index'

  resources :payment_requests, only: %i[index update]
end
