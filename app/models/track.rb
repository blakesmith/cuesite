class Track < ActiveRecord::Base
  belongs_to :cuesheet
  belongs_to :song
end
