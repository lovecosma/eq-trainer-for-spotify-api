class Album < ApplicationRecord
    scope :most_recent_top_albums, -> { reorder(created_by: :asc) }
end
