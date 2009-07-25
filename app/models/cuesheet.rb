class Cuesheet < ActiveRecord::Base
  has_many :tracks

  validates_presence_of :performer, :title, :file

  attr_accessor :file, :indices, :performers, :cue_performer, :cue_title, :titles, :track_numbers

  def self.load_from_file(file)
    parsed = parse_cue_file(file)
    cue = Cuesheet.create(:cue_performer => parsed[:cue_performer], :cue_title => parsed[:cue_title])
    parsed.each do |track|
      song = Song.find_or_create_by_performer_and_title_and_remix(:performer => track[:performer], :title => track[:title], :remix => track[:remix])
      track = Track.create(:cuesheet => cue, :song => song, :minutes => parsed[:minutes], :seconds => parsed[:seconds], :frames => parsed[:frames])
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

    parsed = {:cuesheet => {:performer => cue_performer, :title => cue_title}, :tracks => []}
    tracks = []
    (0..track_numbers.size - 1).each do |i|
      tracks << {:performer => performers[i], :title => titles[i], :index => indices[i], :track => track_numbers[i]}
    end 
    parsed[:tracks] = tracks
    parsed
  end

end
