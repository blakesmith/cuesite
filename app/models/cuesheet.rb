class Cuesheet < ActiveRecord::Base
  has_many :tracks

  validates_presence_of :performer, :title, :file

  attr_accessor :file, :indices

  def load_from_file(file)
    @file = File.open(file).read
  end

  def parse_indices
    @indices = @file.scan(/INDEX \d{1,2} (\d{1,3}):(\d{1,2}):(\d{1,2})/)
  end

end
