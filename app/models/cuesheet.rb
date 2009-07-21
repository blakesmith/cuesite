class Cuesheet < ActiveRecord::Base
  has_many :tracks

  validates_presence_of :performer, :title, :file

  attr_accessor :file, :indices, :performers, :cue_performer, :cue_title, :titles, :track_numbers

  def load_from_file(file)
    @file = File.open(file).read
  end

  def parse_indices
    @indices = @file.scan(/INDEX \d{1,2} (\d{1,3}):(\d{1,2}):(\d{1,2})/).collect do |index|
      index.collect do |values|
        values.to_i
      end
    end
  end

  def parse_performers
    @performers = @file.scan(/PERFORMER \"(.*)\"/).collect {|performer| performer[0]}
    @cue_performer = @performers[0]
    @performers.delete_at(0)
  end

  def parse_titles
    @titles = @file.scan(/TITLE \"(.*)\"/).collect {|title| title[0]}
    @cue_title = @titles[0]
    @titles.delete_at(0)
  end

  def parse_track_numbers
    @track_numbers = @file.scan(/TRACK (\d{1,3}) AUDIO/).collect {|track| track[0].to_i}
  end

  def parse_cue_file(file)
    load_from_file(file)
    parse_indices
    parse_performers
    parse_titles
    parse_track_numbers
    parsed = []
    (0..@track_numbers.size).each do |i|
      parsed << {:performer => @performers[i], :title => @titles[i], :index => @indices[i], :track => @track_numbers[i]}
    end 
    parsed
  end

end
