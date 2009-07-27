class Track < ActiveRecord::Base

  validates_presence_of :track_num

  belongs_to :cuesheet
  belongs_to :song

  def add_zeros(i)
    num = '0' + i.to_s if i < 10
    num = i.to_s if i >= 10
    num
  end

  def to_cuesheet
    cue = "\sTRACK #{add_zeros(track_num)} AUDIO\n"
    cue << "\s\s\sPERFORMER \"#{song.performer}\"\n"
    cue << "\s\s\sTITLE \"#{song.title}\"\n"
    cue << "\s\s\sINDEX 01 #{add_zeros(minutes)}:#{add_zeros(seconds)}:#{add_zeros(frames)}\n"
  end

end
