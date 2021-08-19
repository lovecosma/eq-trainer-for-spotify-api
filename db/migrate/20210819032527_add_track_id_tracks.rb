class AddTrackIdTracks < ActiveRecord::Migration[6.1]
  def change
    add_column :tracks, :track_id, :string
  end
end
