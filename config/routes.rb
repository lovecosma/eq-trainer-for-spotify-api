Rails.application.routes.draw do
  get '/auth/spotify/callback', to: 'users#get_spotify_authorization'
  get '/login', to: "users#login"
  get '/login_with_spotify', to: "users#login_with_spotify"
  scope :api do
    get '/top_albums', to: "albums#top_albums"
    post '/logout', to: "users#logout"
    resources :albums
    resources :users 
    resources :playlists
  end 
end
