class AddFkCuesheet < ActiveRecord::Migration
  def self.up
    add_column :tracks, :cuesheet_id, :integer
  end

  def self.down
    remove_column :tracks, :cuesheet_id
  end
end
