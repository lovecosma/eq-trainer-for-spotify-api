class TracksController < ApplicationController

    def show
       track = Track.find(params[:id])

       if track 
            render json: track
       else 
            
       end 
        
    end 

end
