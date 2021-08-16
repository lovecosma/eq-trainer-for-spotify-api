class CreateTracks < ActiveRecord::Migration[6.1]
  def change
    create_table :tracks do |t|
      t.string :name
      t.string :preview_url
      t.string :artist
      t.timestamps
    end
  end
end
