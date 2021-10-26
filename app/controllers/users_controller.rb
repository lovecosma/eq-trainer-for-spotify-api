class UsersController < ApplicationController
    include ApplicationHelper
    include ActionController::Cookies

    def show
        user = User.find(session[:user_id])
        if(!!user)
            render json: user.to_json(:include => :playlists)
        else
            render json: user.errors, status: :unprocessable_entity
        end

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

    def logout
        session.clear
        render json: {}
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
        session[:access_token] = auth_params["access_token"]
        session[:refresh_token] = auth_params["refresh_token"]
        redirect_to "/get_info"
    end 
    
    
    def create_spotify_user
        header = {
            Authorization: "Bearer #{session["access_token"]}"
        }
        user_response = RestClient.get("https://api.spotify.com/v1/me", header)
        user_info = JSON.parse(user_response.body)
        @user = User.find_or_create_by(display_name: user_info["display_name"])
            # spotify_id: user_info["id"], 
            # api_url: user_info["href"],
            # image_url: user_info["images"].first["url"]
        # )
        header = {
            Authorization: "Bearer #{session["access_token"]}"
        }
        user_response = RestClient.get("https://api.spotify.com/v1/me/playlists", header)
        user_playlists = JSON.parse(user_response.body)["items"]
        user_playlists.each do |playlist|
           p =  Playlist.find_or_create_by(playlist_id: playlist["id"])
           @user.playlists << p if !@user.playlists.include?(p.id) && p.update( name: playlist["name"], tracks_url: playlist["tracks"]["href"])
        end 
        session[:user_id] = @user.id
        token = encode_token session[:access_token]
        redirect_to "http://localhost:3000/users/#{@user.id}/initialize"
    end 


    def user_tracks
        user = User.find(params[:user_id])
        render json: user.tracks
    end 
    
     
   
    
    end
    