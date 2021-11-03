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
                p.tracks_url = playlist_hash["tracks"]["href"]
                p.spotify_id = playlist_hash["id"]
            end 
            user.playlists << playlist if !user.playlists.include?(playlist) 
        end 

        render json: user.playlists.to_json
    
    end 


    def show
        
        playlist = Playlist.find(params[:id])
        headers = {
            Authorization: "Bearer #{session[:access_token]}"
        }
        user = User.find(session[:user_id])
        
        playlists_response = RestClient.get(playlist.tracks_url, headers)
        tracks_data = JSON.parse(playlists_response)
        tracks_data["items"].each do |track_hash|
            track = Track.find_or_create_by(track_id: track_hash["track"]["id"]) do |t|
                t.name = track_hash["track"]["name"]
                t.preview_url = track_hash["track"]["preview_url"]
                t.artist = track_hash["track"]["artists"].first["name"]
                t.album_art = track_hash["track"]["album"]["images"].first
            end 
            playlist.tracks << track if !playlist.tracks.include?(track) 
        end 
        
        render json: playlist.to_json(:include => :tracks)
        
    end 



     
   
end
