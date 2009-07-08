class Cuesheet < ActiveRecord::Base
  has_many :tracks

  validates_presence_of :performer, :title, :file
end
