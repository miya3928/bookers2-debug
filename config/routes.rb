Rails.application.routes.draw do
  devise_for :users

  root to: 'homes#top'
  get "home/about", to: "homes#about"

  resources :books, only: [:index,:show,:edit,:create,:destroy,:update] do
   resources :book_comments, only: [:create, :destroy]  
   resource :favorite, only: [:create, :destroy]
  end 
  
  resources :users, only: [:index,:show,:edit,:update,:create] do
   resource :relationships, only: [:create, :destroy]
    get "followings" => "relationships#followings", as: "followings"
  	 get "followers" => "relationships#followers", as: "followers"
  end
  
  get "/search", to: "searches#search"

  resources :chats, only: [:show, :create, :destroy]
  
end