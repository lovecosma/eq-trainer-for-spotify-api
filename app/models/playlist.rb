class Playlist < ApplicationRecord
    belongs_to :user
    has_and_belongs_to_many :tracks
    # validate :check_for_empty_track_urls
end
