class Cuesheet < ActiveRecord::Base
  has_many :tracks

  validates_presence_of :performer, :title, :file

  attr_accessor :file, :indices, :performers, :cue_performer, :cue_title, :titles, :track_numbers

  def load_from_file(file)
    @file = File.open(file).read
  end

  def parse_indices
    @indices = @file.scan(/INDEX \d{1,2} (\d{1,3}):(\d{1,2}):(\d{1,2})/)
  end

  def parse_performers
    @performers = @file.scan(/PERFORMER \"(.*)\"/)
    @cue_performer = @performers[0]
    @performers.delete_at(0)
  end

  def parse_titles
    @titles = @file.scan(/TITLE \"(.*)\"/)
    @cue_title = @titles[0]
    @titles.delete_at(0)
  end

  def parse_track_numbers
    @track_numbers = @file.scan(/TRACK (\d{1,3}) AUDIO/)
  end

end
