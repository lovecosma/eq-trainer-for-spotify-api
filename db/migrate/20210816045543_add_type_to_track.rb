class AddTypeToTrack < ActiveRecord::Migration[6.1]
  def change
    add_column :tracks, :type, :string
  end
end
