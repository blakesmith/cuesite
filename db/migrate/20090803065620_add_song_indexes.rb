class AddSongIndexes < ActiveRecord::Migration
  def self.up
    add_index :songs, :title
    add_index :songs, :remix
    add_index :songs, :performer
  end

  def self.down
    remove_index :songs, :column => :performer
    remove_index :songs, :column => :remix
    remove_index :songs, :column => :title
  end
end
