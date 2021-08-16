class Track < ApplicationRecord
    has_and_belongs_to_many :playlists
    scope :top_tracks, -> {where(name: "Preview")}
end
