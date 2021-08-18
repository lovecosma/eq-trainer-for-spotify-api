Rails.application.routes.draw do
  resources :albums
  get '/login', to: "users#login"
  post '/logout', to: "users#logout"
  get '/auth/spotify/callback', to: 'users#get_spotify_authorization'
  get '/get_info', to: "users#create_spotify_user"
  get '/top_albums', to: "albums#top_albums"
  resources :users do 
      get "/tracks", to: "users#user_tracks"
  end
# For details on the DSL available within this file, see https://guides.rubyonrails.org/routing.html
end
