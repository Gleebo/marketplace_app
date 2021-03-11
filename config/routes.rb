Rails.application.routes.draw do
  root "listings#index"
  devise_for :users
  resources :listings
  get "/user/listings", to: "listings#user_listings", as: "user_listings"
  get "/search", to: "listings#search", as: "search"
  get "/payments/success", to: "payments#success"
  get "/payments/webhook", to: "payments#webhook"
end
