class PlaylistsController < ApplicationController


    def index  
        headers = {
            Authorization: "Bearer #{session[:access_token]}"
        }
        user = User.find(session[:user_id])
        
        playlists_response = RestClient.get("https://api.spotify.com/v1/me/playlists", headers)
        playlists_data = JSON.parse(playlists_response)

        playlists_data["items"].each do |playlist_hash|
            playlist = Playlist.find_or_create_by(spotify_id: playlist_hash["id"]) do |p|
                p.name = playlist_hash["name"]
                p.spotify_id = playlist_hash["id"]
            end 
            user.playlists << playlist if !user.playlists.include?(playlist)  
        end 

        render json: user.playlists.to_json
    
    end 


    def show
        playlist = Playlist.find(params[:id])
        get_playlist_tracks(playlist, session[:access_token])
        render json: playlist.to_json(:include => :tracks)
    end 



     
   
end
