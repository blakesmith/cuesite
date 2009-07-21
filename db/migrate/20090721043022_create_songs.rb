class CreateSongs < ActiveRecord::Migration
  def self.up
    create_table :songs do |t|
      t.string :performer
      t.string :title
      t.string :remix

      t.timestamps
    end
  end

  def self.down
    drop_table :songs
  end
end
