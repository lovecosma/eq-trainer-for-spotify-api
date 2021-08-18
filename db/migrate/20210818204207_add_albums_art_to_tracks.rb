class AddAlbumsArtToTracks < ActiveRecord::Migration[6.1]
  def change
    add_column :tracks, :album_art, :string
  end
end
