require 'test_helper'

class CuesheetTest < ActiveSupport::TestCase
  fixtures :cuesheets

  should 'load fixtures' do
    cuesheet = cuesheets(:steve_mac)
    assert cuesheet
    assert_equal cuesheet.performer, 'Steve Mac'
    assert_equal cuesheet.title, 'Essential Mix (2008-10-25) [TMB]'
  end

  should 'load fixture replacement' do
    cuesheet = create_cuesheet
    assert cuesheet
  end

  should 'load from file' do
    cue = Cuesheet.new
    assert_nothing_raised do
      cue.load_from_file('test/fixtures/test.cue')
    end
  end

  context 'load from file' do
    setup do
      @cue = Cuesheet.new
      @cue.load_from_file('test/fixtures/test.cue')
    end

    should 'regex match track number' do
      @cue.parse_track_numbers
      assert_equal 35, @cue.track_numbers.size
    end

    should 'regex match track index' do
      @cue.parse_indices
      assert_equal 35, @cue.indices.size
    end

    should 'regex match performer' do
      @cue.parse_performers
      assert_equal 35, @cue.performers.size
      assert_equal 1, @cue.cue_performer.size
    end

    should 'regex match titles' do
      @cue.parse_titles
      assert_equal 35, @cue.titles.size
      assert_equal 1, @cue.cue_title.size
    end

  end

end
