Rails.application.routes.draw do

  get '/home' => 'home#index'
  post "/home", to: "home#create"
  get "/posts/:id", to: "home#show"
  delete "/posts/:id", to: "home#destroy"
  get "posts/:id/edit", to: "home#edit"
  patch "/posts/:id/edit", to: "home#update", as: "edit_post"

  # comments routes
  post "/posts/:id", to: "comments#create", as: "comments"
  # Define your application routes per the DSL in https://guides.rubyonrails.org/routing.html

  get "up" => "rails/health#show", as: :rails_health_check

  # Defines the root path route ("/")
  # root "posts#index"
end
