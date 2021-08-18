class User < ApplicationRecord
    has_many :playlists
    has_many :tracks, through: :playlists

    def access_token_expired?
        Time.now - self.updated_at > 3300
    end 
end
