Rails.application.routes.draw do
  get 'landing/index'
  devise_for :users

  # Landing page as the root page for unauthenticated users
  unauthenticated :user do
    root 'landing#index', as: :unauthenticated_root
  end

  namespace :admin do
    root to: "dashboard#index" # Admin dashboard
    resources :users do
      member do
        patch :activate
        patch :deactivate
      end
    end
  end

  # Home page for logged-in users
  authenticated :user do
    root 'home#index', as: :authenticated_root
  end
  get '/home' => 'home#index'
  post "/home", to: "home#create"
  get "/posts/:id", to: "home#show"
  delete "/posts/:id", to: "home#destroy"
  get "posts/:id/edit", to: "home#edit"
  patch "/posts/:id/edit", to: "home#update", as: "edit_post"

  # comments routes
  post "/posts/:id", to: "comments#create", as: "comments"

  # Likes routes (Polymorphic: supports both Posts & Comments)
  resources :posts do
    resources :likes, only: [:create, :destroy], defaults: { likeable_type: "Post" }
  end

  resources :comments do
    resources :likes, only: [:create, :destroy], defaults: { likeable_type: "Comment" }
  end
  
  get "up" => "rails/health#show", as: :rails_health_check
  root 'landing#index' 

end
