Rails.application.routes.draw do
  
  devise_for :users
  root to: 'homes#top'
  get '/about' => 'homes#about'
  resources :users, only: [:show, :edit, :update, :index]
  get '/users/search' => 'users#search'
end
