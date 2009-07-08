class Track < ActiveRecord::Base
  belongs_to :cuesheet

  validates_presence_of :performer, :title
  validates_numericality_of :minutes, :seconds, :frames
end
