Rails.application.routes.draw do
  
  resources :articles
  root 'pages#home'
  get 'about', to: 'pages#about'
  get 'home', to: 'pages#home'
  get 'signup', to: 'users#new'
  resources :users, expect: [:new]    

   
end
