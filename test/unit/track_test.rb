require 'test_helper'

class TrackTest < ActiveSupport::TestCase
  fixtures :tracks

  should 'load fixtures' do
    track = tracks(:one)
    assert track
    assert_equal track.minutes, 0
  end

  should 'load fixture replacement' do
    track = create_track
    cuesheet = create_cuesheet
    assert_equal 1, track.minutes
    assert_equal 41, track.seconds
  end

end
