class AddCueFileToCuesheet < ActiveRecord::Migration
  def self.up
    add_column :cuesheets, :cue_file, :string
  end

  def self.down
    remove_column :cuesheets, :cue_file
  end
end
