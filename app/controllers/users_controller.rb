class UsersController < ApplicationController
    include ApplicationHelper
    
    def show
        @user = User.find(params[:id])
        render json: @user.to_json(:include => {
            :playlists => {:include => :tracks },
        })
    end 
    
    def login
        url = "https://accounts.spotify.com/authorize"
        query_params = {
            client_id: Rails.application.credentials.spotify[:client_id],
            response_type: "code",
            redirect_uri: "http://localhost:3001/auth/spotify/callback",
            scope: "playlist-modify-public playlist-read-collaborative user-library-read"
        }
        redirect_to spotify_url = url + "?" +  query_params.to_query
    end 
    
    def get_spotify_authorization
        url = "https://accounts.spotify.com/api/token"
        body = {
            grant_type: "authorization_code",
            code: params[:code],
            redirect_uri: "http://localhost:3001/auth/spotify/callback",
            client_id: Rails.application.credentials.spotify[:client_id],
            client_secret: Rails.application.credentials.spotify[:client_secret]
        }
        resp = RestClient.post(url, body)
        auth_params = JSON.parse(resp.body)
        
        payload = {
            access_token: auth_params["access_token"],
            refresh_token: auth_params["refresh_token"]
        }
        token = encode_token(payload)
        redirect_to "http://localhost:3000/login_success/" +  token
    end 
    
    
    def create_spotify_user
        payload = decode_token(request.headers["Authorization"])
     
        header = {
            Authorization: "Bearer #{payload.first["access_token"]}"
        }
        user_response = RestClient.get("https://api.spotify.com/v1/me", header)
        user_info = JSON.parse(user_response.body)
        @user = User.find_or_create_by(display_name: user_info["display_name"], 
        spotify_id: user_info["id"], 
        api_url: user_info["href"]
        )
        session[:user_id] = @user.id
        playlists = get_user_playlists(payload.first["access_token"])
        releases_response = RestClient.get("https://api.spotify.com/v1/browse/new-releases", header)
        new_releases = JSON.parse(releases_response.body)
        render json: @user.to_json(:include => {
            :playlists => {:include => :tracks },
        })
    end 
    
    private 
    
    def get_user_playlists(token)
        header = {
            Authorization: "Bearer #{token}"
        }
        user_response = RestClient.get("https://api.spotify.com/v1/me/playlists", header)
        user_playlists = JSON.parse(user_response.body)["items"]
        user_playlists.each do |playlist|
           p =  Playlist.find_or_create_by(
                name: playlist["name"],
                tracks_url: playlist["tracks"]["href"]
            )
            current_user.playlists << p
            get_playlist_tracks(p, token)
        end 
    end 
    
    def get_playlist_tracks(playlist, token)
    
        header = {
            Authorization: "Bearer #{token}"
        }
        user_response = RestClient.get(playlist.tracks_url, header)
        playlist_tracks = JSON.parse(user_response.body)
        playlist_tracks["items"].each do |track|
            if track["track"]["preview_url"]
            t = Track.find_or_create_by(
                name: track["track"]["name"],
                preview_url: track["track"]["preview_url"],
                artist: track["track"]["artist"]
                )
                playlist.tracks << t
            end 
        end 
        if playlist.tracks.empty?
            playlist.delete
        end 
    
    end 
    
    
    end
    