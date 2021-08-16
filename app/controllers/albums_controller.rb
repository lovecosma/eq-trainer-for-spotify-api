class AlbumsController < ApplicationController

    def top_albums
        render json: Album.most_recent_top_albums
    end 
end
