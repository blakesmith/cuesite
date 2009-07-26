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

  should 'add zeros if under 10' do
    track = create_track
    assert_equal('03', track.add_zeros(3))
  end

  should 'add zeros if over 10' do
    track = create_track
    assert_equal('13', track.add_zeros(13))
  end

end
