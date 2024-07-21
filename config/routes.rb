Rails.application.routes.draw do
  
  resources :articles
  root 'pages#home'
  get 'about', to: 'pages#about'
  get 'home', to: 'pages#home'
  get 'signup', to: 'users#new'
  resources :users, expect: [:new]    
  get 'login', to: 'sessions#new'
  post 'login', to: 'sessions#create'
  get '/logout', to: 'sessions#destroy', as: :logout
  resources :categories, expect: [:destroy]



end
