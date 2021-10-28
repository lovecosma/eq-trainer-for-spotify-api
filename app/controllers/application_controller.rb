class ApplicationController < ActionController::API

include ActionController::Cookies


protected 

def current_user
    @user = User.find(session[:user_id])
    return @user
end 

def autheticate
end 

def encode_token(payload)
    JWT.encode payload, Rails.application.credentials.secret_key_base, 'HS256'
end 

def auth_header 
    request.headers["Authorization"]
end 

def decoded_token
    if auth_header
        token = auth_header.split(' ')[1]
        begin
            JWT.decode token, Rails.application.credentials.secret_key_base, true, { :algorithm => 'HS256' }
          rescue JWT::DecodeError
            nil
        end
    end 
end 

    
end
