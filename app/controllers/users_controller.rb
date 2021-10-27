class UsersController < ApplicationController
    include ApplicationHelper
    include ActionController::Cookies

    def show
        user = User.find(session[:user_id])
        if(!!user)
            render json: user
        else
            render json: user.errors, status: :unprocessable_entity
        end

    end 

    
    def login_with_spotify
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
        new_releases = RestClient.get("https://api.spotify.com/v1/browse/new-releases", {
            Authorization: "Bearer #{session["access_token"]}"
        })
        nr_info = JSON.parse(new_releases.body)
        nr_info["albums"]["items"].each do |album|
            Album.find_or_create_by(name: album["name"]) do |album|
                album.image = album["images"][0]["url"]
            end 
        end 
        redirect_to "/login"
    end 
    
    
    def login
        header = {
            Authorization: "Bearer #{session["access_token"]}"
        }
        user_response = RestClient.get("https://api.spotify.com/v1/me", header)
        user_info = JSON.parse(user_response.body)
        @user = User.find_or_create_by(display_name: user_info["display_name"]) do |user|
            user.image_url = user_info["images"][0]["url"]
        end 
        session[:user_id] = @user.id
        cookies[:user] = @user.to_json
        redirect_to "http://localhost:3000/users/#{@user.id}"
    end 


    def user_tracks
        user = User.find(params[:user_id])
        render json: user.tracks
    end 
    
     
   
    
    end
    