class AlbumsController < ApplicationController

    def top_albums
        # binding.pry
        render json: Album.most_recent_top_albums.limit(20)
    end 
end
