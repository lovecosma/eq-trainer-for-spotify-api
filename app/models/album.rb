class Album < ApplicationRecord
    scope :most_recent_top_albums, -> { reorder(created_at: :asc) }
end
