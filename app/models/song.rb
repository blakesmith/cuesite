class Song < ActiveRecord::Base
  has_many :tracks
end
