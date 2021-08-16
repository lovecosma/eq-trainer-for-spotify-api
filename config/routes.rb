Rails.application.routes.draw do
  get '/login', to: "users#login"
  get '/auth/spotify/callback', to: 'users#get_spotify_authorization'
  get '/get_info', to: "users#create_spotify_user"
  get '/top_tracks', to: "tracks#top_tracks"
  resources :users
# For details on the DSL available within this file, see https://guides.rubyonrails.org/routing.html
end
