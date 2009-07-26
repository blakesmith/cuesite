class Track < ActiveRecord::Base

  validates_presence_of :track_num

  belongs_to :cuesheet
  belongs_to :song

  def add_zeros(i)
    num = '0' + i.to_s if i < 10
    num = i.to_s if i >= 10
    num
  end

end
