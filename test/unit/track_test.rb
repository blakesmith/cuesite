require 'test_helper'

class TrackTest < ActiveSupport::TestCase
  fixtures :tracks

  should 'load fixtures' do
    track = tracks(:one)
    assert track
    assert_equal track.title, 'Intro'
    assert_equal track.performer, 'Essential Mix'
  end

  should 'load fixture replacement' do
    track = create_track
    assert track
  end

end
