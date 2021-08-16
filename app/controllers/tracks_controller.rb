class TracksController < ApplicationController

    def top_tracks
        tracks = Track.top_tracks
        render json: tracks 
    end 
end
