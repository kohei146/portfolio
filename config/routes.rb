Rails.application.routes.draw do
  
  devise_for :users
  root to: 'homes#top'
  get '/about' => 'homes#about'
  get '/users/search' => 'users#search'
  resources :users, only: [:show, :edit, :update, :index]
end
