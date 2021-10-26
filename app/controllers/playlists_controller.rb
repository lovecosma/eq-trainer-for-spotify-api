class PlaylistsController < ApplicationController
    def show
        playlist = Playlist.find(params[:id])
        get_playlist_tracks(playlist, session[:access_token])
        render json: playlist.to_json(:include => :tracks)
    end 



    private
     
    def get_playlist_tracks(playlist, token)
    
        header = {
            Authorization: "Bearer #{token}"
        }
        user_response = RestClient.get(playlist.tracks_url, header)
        playlist_tracks = JSON.parse(user_response.body)
        playlist_tracks["items"].each do |track|
            if track["track"]["preview_url"]
                t = Track.find_by(track_id: track["track"]["id"])
                if t
                    playlist.tracks << t     
                else 
                t = playlist.tracks.create(
                    track_id: track["track"]["id"],
                    name: track["track"]["name"],
                    preview_url: track["track"]["preview_url"],
                    artist: track["track"]["artists"].first,
                    album_art: track["track"]["album"]["images"].first["url"]
                    ) 
                end 
            end 
        if playlist.tracks.empty?
            playlist.delete
        end 
    
    end 
end
end
