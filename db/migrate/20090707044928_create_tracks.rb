class CreateTracks < ActiveRecord::Migration
  def self.up
    create_table :tracks do |t|
      t.string :performer
      t.string :title
      t.integer :minutes
      t.integer :seconds
      t.integer :frames

      t.timestamps
    end
  end

  def self.down
    drop_table :tracks
  end
end
