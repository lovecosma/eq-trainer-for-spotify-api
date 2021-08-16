class CreateAlbums < ActiveRecord::Migration[6.1]
  def change
    create_table :albums do |t|
      t.string :album_id
      t.string :name
      t.string :image

      t.timestamps
    end
  end
end
