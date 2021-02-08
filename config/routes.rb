Rails.application.routes.draw do

  devise_for :users
  root to: 'homes#top'
  get '/about' => 'homes#about'
  get '/users/search' => 'users#search'
  resources :users, only: [:show, :edit, :update, :index]
  get '/books/search' => 'books#search'
  resources :books, only: [:index, :show, :create, :edit, :update, :destroy]
end

#書く順番気をつける