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

  should 'return performer, title, and index for .to_cuesheet' do
    cue = create_cuesheet
    song = create_song(:performer => 'blithe', :title => 'resonance', :remix => nil) 
    track = create_track(:track_num => 25, :minutes => 5, :seconds => 30, :frames => 70, :cuesheet => cue, :song => song)
    expected = "\sTRACK 25 AUDIO\n"
    expected << "\s\s\sPERFORMER \"blithe\"\n"
    expected << "\s\s\sTITLE \"resonance\"\n"
    expected << "\s\s\sINDEX 01 05:30:70\n"
    assert_equal(expected, track.to_cuesheet)
  end

  should 'return performer, title, remix and index for .to_cuesheet' do
    cue = create_cuesheet
    song = create_song(:performer => 'blithe', :title => 'resonance', :remix => 'original remix') 
    track = create_track(:track_num => 25, :minutes => 5, :seconds => 30, :frames => 70, :cuesheet => cue, :song => song)
    expected = "\sTRACK 25 AUDIO\n"
    expected << "\s\s\sPERFORMER \"blithe\"\n"
    expected << "\s\s\sTITLE \"resonance (original remix)\"\n"
    expected << "\s\s\sINDEX 01 05:30:70\n"
    assert_equal(expected, track.to_cuesheet)
  end

  should 'index from minutes, seconds, frames' do
    track = create_track :minutes => 3, :seconds => 55, :frames => 65
    assert_equal([3, 55, 65], track.index)
  end

  should 'total_seconds' do
    track = create_track :minutes => 2, :seconds => 45, :frames => 60
    assert_equal(165.8, track.total_seconds)
  end

  should 'calc track_diff no_wrap' do
    track1 = create_track :minutes => 5, :seconds => 45, :frames => 60
    track2 = create_track :minutes => 3, :seconds => 30, :frames => 45
    assert_equal([2, 15, 15], track1.track_diff(track2))
  end

  should 'calc track_diff wrap' do
    track1 = create_track :minutes => 5, :seconds => 45, :frames => 60
    track2 = create_track :minutes => 3, :seconds => 50, :frames => 75
    assert_equal([1, 54, 60], track1.track_diff(track2))
  end

  should 'calc track_diff negative result' do
    track1 = create_track :minutes => 3, :seconds => 50, :frames => 75
    track2 = create_track :minutes => 5, :seconds => 45, :frames => 60
    result = track1.track_diff(track2)
    assert result.is_a?(String)
    assert_equal('neg', result)
  end

  context 'calc track length' do

    setup do
      @cue = create_cuesheet
      @track1 = create_track :minutes => 3, :seconds => 50, :frames => 75, :cuesheet => @cue,
        :track_num => 1
      @track2 = create_track :minutes => 5, :seconds => 45, :frames => 60, :cuesheet => @cue, 
        :track_num => 2
    end

    should 'calc track length' do
      assert_equal([1, 54, 60], @track1.length)
    end

    should 'calc track print_length' do
      assert_equal('01:54', @track1.print_length)
    end

    should 'calc track length with nil (No following track)' do
      @track2.destroy
      assert_equal('unknown', @track1.length)
    end

  end

  should 'print_index' do
    track = create_track :minutes => 3, :seconds => 30, :frames => 35
    assert_equal('03:30', track.print_index)
  end

  should 'print_track_num' do
    track = create_track :track_num => 3
    assert_equal('03', track.print_track_num)
  end
end
