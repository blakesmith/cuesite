class CreateTracks < ActiveRecord::Migration
  def self.up
    create_table :tracks do |t|
      t.integer :minutes
      t.integer :seconds
      t.integer :frames
      t.integer :song_id
      t.integer :cuesheet_id

      t.timestamps
    end

    add_index :tracks, :song_id
  end

  def self.down
    remove_index :tracks, :column => :song_id

    drop_table :tracks
  end
end
