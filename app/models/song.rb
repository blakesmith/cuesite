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

end
