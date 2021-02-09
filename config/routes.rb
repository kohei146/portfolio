Rails.application.routes.draw do

  devise_for :users
  root to: 'homes#top'
  get '/about' => 'homes#about'
  get '/users/search' => 'users#search'
  resources :users, only: [:show, :edit, :update, :index] do
    resource :relationships, only: [:create, :destroy]
  # 	get '/users/:id/followings' => 'users#followings', as: 'followings'
  # 	get '/users/:id/followers' => 'users#followers', as: 'followers'
  	get 'followings' => 'relationships#followings', as: 'followings'
    get 'followers' => 'relationships#followers', as: 'followers'
  end
  
  get '/books/search' => 'books#search'
  resources :books, only: [:index, :show, :create, :edit, :update, :destroy] do
    resource :favorites, only: [:create, :destroy]
  end
end

#書く順番気をつける