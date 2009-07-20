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

    should 'regex match track index' do
      @cue.parse_indices
      assert_equal 35, @cue.indices.size
    end

  end

end
