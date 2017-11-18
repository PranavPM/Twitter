Rails.application.routes.draw do
  get 'twitter_users/new'
  get 'sessions/new'
  root 'static_pages#home'
  get  'static_pages/home'
  get  '/help',    to: 'static_pages#help'
  get  '/about',   to: 'static_pages#about'
  get  '/contact', to: 'static_pages#contact'
  get  '/signup',  to: 'twitter_users#new'
  post  '/signup',  to: 'twitter_users#create'
  get    '/login',   to: 'sessions#new'
  post   '/login',   to: 'sessions#create'
  delete '/logout',  to: 'sessions#destroy'


  get 'auth/:provider/callback', to: 'sessions#create'
  # resources :TestimoniesController, only: [:index, :destroy , :search]
  get '/index', to: 'testimonies#index'
  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html
  resources :twitter_users,:testimonies
  get '/search', to: 'testimonies#search'
  delete '/destroy', to: 'testimonies#destroy'
end
