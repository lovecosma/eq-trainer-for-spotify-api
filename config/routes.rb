Rails.application.routes.draw do
  get '/auth/spotify/callback', to: 'users#get_spotify_authorization'
  get '/get_info', to: "users#create_spotify_user"
  get '/login', to: "users#login"
  scope :api do
    get '/top_albums', to: "albums#top_albums"
    post '/logout', to: "users#logout"
    resources :albums
    resources :users 
  end 
end
