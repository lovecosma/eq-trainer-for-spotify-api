Rails.application.routes.draw do
  resources :albums
  get '/login', to: "users#login"
  post '/logout', to: "users#logout"
  get '/auth/spotify/callback', to: 'users#get_spotify_authorization'
  get '/get_info', to: "users#create_spotify_user"
  get '/top_albums', to: "albums#top_albums"
  namespace :api do
    resources :users 
  end 
end
