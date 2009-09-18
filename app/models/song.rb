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
  named_scope :has_remix, :conditions => ['remix IS NOT ?', nil]
  named_scope :no_remix, :conditions => ['remix IS ?', nil]
  has_many :tracks

  def parse_remix
    re = title.scan(/\((.*?)\)/).join ", "
    ti = title.gsub(/\((.*?)\)/, '').chomp("\s")
    if re.empty?
      re = title.scan(/\[(.*?)\]/).join ", "
      ti = title.gsub(/\[(.*?)\]/, '').chomp("\s")
    end
    ti = ti.gsub /\s\s/, "\s" # strip duplicate spaces
    unless re.empty?
      self.update_attributes(:remix => re, :title => ti)
    end
  end

  def print_remix
    return '' if remix.nil?
    " (#{remix})"
  end

  def all_remixes
    songs = Song.has_remix.all(:conditions => { :performer => performer, :title => title })
  end

  def remix_count
    all_remixes.size
  end

  def all_cuesheets
    tracks.collect(&:cuesheet)
  end

end
