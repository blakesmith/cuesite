class Cuesheet < ActiveRecord::Base
  has_many :tracks

  validates_presence_of :performer, :title, :file

  def self.load_from_file(file)
    parsed = parse_cue_file(file)
    cue = Cuesheet.create(:performer => parsed[:cuesheet][:performer], :title => parsed[:cuesheet][:title], :file => parsed[:cuesheet][:file], :cue_file => file.split('/').last)
    parsed[:tracks].each do |track|
      song = Song.find_or_create_by_performer_and_title_and_remix(:performer => track[:performer], :title => track[:title], :remix => track[:remix])
      new_track = Track.create(:cuesheet => cue, :song => song, :minutes => track[:index][0], :seconds => track[:index][1], :frames => track[:index][2], :track_num => track[:track])
    end
  end

  def self.parse_cue_file(file)
    f = File.open(file).read

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
      cue << "\sTRACK #{track.add_zeros(track.track_num)} AUDIO\n"
      cue << "\s\s\sPERFORMER \"#{track.song.performer}\"\n"
      cue << "\s\s\sTITLE \"#{track.song.title}\"\n"
      cue << "\s\s\sINDEX 01 #{track.add_zeros(track.minutes)}:#{track.add_zeros(track.seconds)}:#{track.add_zeros(track.frames)}\n"
    end
    cue
  end

end
