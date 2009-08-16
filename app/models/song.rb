# == Schema Information
# Schema version: 20090803065620
#
# Table name: songs
#
#  id         :integer(4)      not null, primary key
#  performer  :string(255)
#  title      :string(255)
#  remix      :string(255)
#  created_at :datetime
#  updated_at :datetime
#

class Song < ActiveRecord::Base
  has_many :tracks

  def parse_remix
    re = title.scan(/\((.*)\)/).to_s.chomp("\s")
    ti = title.scan(/(.*)\(.*\)/).to_s.chomp("\s")
    if re.empty?
      re = title.scan(/\[(.*)\]/).to_s.chomp("\s")
      ti = title.scan(/(.*)\[.*\]/).to_s.chomp("\s")
    end
    if ! re.empty?
      self.remix = re
      self.title = ti
      self.save
    end
  end

  def print_remix
    return '' if remix.nil?
    " (#{remix})"
  end

  def track_instances
    Track.all(:conditions => {:song_id => self.id})
  end

  def track_count
    track_instances.size
  end

  def all_remixes
    remixes = Song.all(:conditions => {:performer => performer, :title => title}).map(&:remix)
    remixes.each_with_index do |remix, i|
      remixes.delete_at(i) if remix.nil?
    end
    remixes
  end

  def remix_count
    all_remixes.size
  end

end
