class ApplicationController < ActionController::API



protected 

def current_user
    @user = User.find(session[:user_id])
    return @user
end 

def encode_token(payload)
    token = JWT.encode payload, Rails.application.credentials.secret_key_base, 'HS256'
    return token
end 

def decode_token(token)
    decoded_token = JWT.decode token, Rails.application.credentials.secret_key_base, true, { :algorithm => 'HS256' }
    return decoded_token
end 

    
end
