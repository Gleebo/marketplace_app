Rails.application.routes.draw do
  get 'reviews/new'
  get 'reviews/show'
  get 'reviews/delete'
  root "listings#index"
  devise_for :users
  resources :listings
  get "/user/listings", to: "listings#user_listings", as: "user_listings"
  get "/user/purchases", to: "listings#show_purchases", as: "purchases"
  get "/search", to: "listings#search", as: "search"
  get "/payments/success", to: "payments#success"
  post "/payments/webhook", to: "payments#webhook"
  get "/reviews/new/:id", to: "reviews#new"
  post "/reviews/new", to: "reviews#create"
end
