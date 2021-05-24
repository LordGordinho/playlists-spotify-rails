require 'sidekiq/web'

Rails.application.routes.draw do
  root 'home#index'
  mount Sidekiq::Web => '/sidekiq'
  devise_for :users

  resources :playlists
  resources :musics
  
  get '/auth/spotify/callback', to: 'home#index'
end
