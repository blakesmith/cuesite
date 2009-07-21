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
      assert_equal "Steve Mac", @cue.cue_performer
    end

    should 'regex match titles' do
      @cue.parse_titles
      assert_equal 35, @cue.titles.size
      assert_equal "Essential Mix (2008-10-25) [TMB]", @cue.cue_title
    end

  end
    
  should 'return list of hashes for cuesheet data' do
    @cue = create_cuesheet
    sheet = @cue.parse_cue_file('test/fixtures/test.cue')
    test_hash = {:performer => "Essential Mix", :title => "Intro", :index => [0, 0, 0], :track => 1}
    test_hash2 = {:performer => "Marc Houle", :title => "Meatier Shower", :index => [1, 41, 13], :track => 2}
    assert_equal test_hash, sheet[0]
    assert_equal test_hash2, sheet[1]
  end


end
