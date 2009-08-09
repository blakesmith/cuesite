# == Schema Information
# Schema version: 20090803065620
#
# Table name: tracks
#
#  id          :integer(4)      not null, primary key
#  minutes     :integer(4)
#  seconds     :integer(4)
#  frames      :integer(4)
#  song_id     :integer(4)
#  cuesheet_id :integer(4)
#  created_at  :datetime
#  updated_at  :datetime
#  track_num   :integer(4)
#

class Track < ActiveRecord::Base

  validates_presence_of :track_num

  belongs_to :cuesheet
  belongs_to :song

  def add_zeros(i)
    num = '0' + i.to_s if i < 10
    num = i.to_s if i >= 10
    num
  end

  def index
    [minutes, seconds, frames]
  end

  def print_index
    i = index
    "#{add_zeros(index[0])}:#{add_zeros(index[1])}"
  end

  def print_track_num
    "#{add_zeros(track_num)}"
  end

  def total_seconds
    (minutes * 60) + seconds + (frames / 75.0)
  end

  def to_cuesheet
    cue = "\sTRACK #{add_zeros(track_num)} AUDIO\n"
    cue << "\s\s\sPERFORMER \"#{song.performer}\"\n"
    cue << "\s\s\sTITLE \"#{song.title}\"\n"
    cue << "\s\s\sINDEX 01 #{add_zeros(minutes)}:#{add_zeros(seconds)}:#{add_zeros(frames)}\n"
  end

  def track_diff(other_track)
    return 'unknown' if other_track.nil?
    diff = total_seconds - other_track.total_seconds
    return 'neg' if diff < 0
    min = (diff / 60).to_i
    diff = diff - (min * 60)
    sec = diff.to_i
    frm = ((diff - sec) * 75).to_i
    [min, sec, frm]
  end

  def length
    return 'unknown' if cuesheet.tracks[track_num].nil?
    cuesheet.tracks[track_num].track_diff(self)
  end

  def print_length
    return 'unknown' if cuesheet.tracks[track_num].nil?
    len = cuesheet.tracks[track_num].track_diff(self)
    "#{add_zeros(len[0])}:#{add_zeros(len[1])}"
  end

end
