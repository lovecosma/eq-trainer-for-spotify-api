class CreatePlaylists < ActiveRecord::Migration[6.1]
  def change
    create_table :playlists do |t|
      t.string :name
      t.string :tracks_url
      t.integer :user_id
      t.timestamps
    end
  end
end
