class AddTrackNumToTrack < ActiveRecord::Migration
  def self.up
    add_column :tracks, :track_num, :integer
  end

  def self.down
    remove_column :tracks, :track_num
  end
end
