Rails.application.routes.draw do
  get 'payments/success'
  get 'payments/webhook'
  root "listings#index"
  get '/search', to: 'listings#search', as: 'search'
  devise_for :users
  resources :listings
  get "/user/listings", to: "listings#user_listings", as: "user_listings"
  get "/payments/success", to: "payments#success"
end
