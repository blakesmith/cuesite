# == Schema Information
# Schema version: 20090803065620
#
# Table name: cuesheets
#
#  id         :integer(4)      not null, primary key
#  performer  :string(255)
#  title      :string(255)
#  file       :string(255)
#  created_at :datetime
#  updated_at :datetime
#  cue_file   :string(255)
#

class Cuesheet < ActiveRecord::Base
  has_many :tracks

  validates_presence_of :performer, :title, :file

  def self.load_from_file(file, filename=nil)
    parsed = parse_cue_file(file)
    if filename.nil?
      cue_file = file.split('/').last 
    else
      cue_file = filename.split('/').last
    end
    cue = Cuesheet.new(:performer => parsed[:cuesheet][:performer], :title => parsed[:cuesheet][:title], :file => parsed[:cuesheet][:file], :cue_file => cue_file)
    parsed[:tracks].each do |track|
      song = Song.find_or_create_by_performer_and_title_and_remix(:performer => track[:performer], :title => track[:title], :remix => track[:remix])
      song.parse_remix
      new_track = Track.create(:cuesheet => cue, :song => song, :minutes => track[:index][0], :seconds => track[:index][1], :frames => track[:index][2], :track_num => track[:track])
    end
    cue if cue.save
  end

  def self.parse_cue_file(file)
    if File.exists?(file)
      f = File.open(file).read 
    elsif file.is_a?(String)
      f = file # The string for the file was passed in instead of the filename
    end

    performers = f.scan(/PERFORMER \"(.*)\"/).collect {|performer| performer[0]}
    cue_performer = performers[0]
    performers.delete_at(0)

    titles = f.scan(/TITLE \"(.*)\"/).collect {|title| title[0]}
    cue_title = titles[0]
    titles.delete_at(0)

    indices = f.scan(/INDEX \d{1,2} (\d{1,3}):(\d{1,2}):(\d{1,2})/).collect do |index|
      index.collect do |values|
        values.to_i
      end
    end

    track_numbers = f.scan(/TRACK (\d{1,3}) AUDIO/).collect {|track| track[0].to_i}
    file_title = f.scan(/FILE \"(.*)\"/).first[0]

    parsed = {:cuesheet => {:performer => cue_performer, :title => cue_title, :file => file_title}, :tracks => []}
    tracks = []
    (0..track_numbers.size - 1).each do |i|
      tracks << {:performer => performers[i], :title => titles[i], :index => indices[i], :track => track_numbers[i]}
    end 
    parsed[:tracks] = tracks
    parsed
  end

  def to_cuesheet
    cue = "PERFORMER \"#{performer}\"\n"
    cue << "TITLE \"#{title}\"\n"
    cue << "FILE \"#{file}\" #{file.split('.').last.upcase}\n"
    tracks.each do |track|
      cue << track.to_cuesheet
    end
    cue
  end

  def delete
    tracks.each do |track|
      # No more cuesheet associated with this song
      if Track.all(:conditions => {:song_id => track.song.id}).size == 1
        track.song.destroy
      end
    end
    if tracks.destroy_all && self.destroy
      true
    else
      false
    end
  end

end
