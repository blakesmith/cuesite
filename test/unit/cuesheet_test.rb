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

  context 'load from file' do

    setup do
      @sheet = Cuesheet.parse_cue_file('test/fixtures/test.cue')
    end

    should 'return overall performer and title' do
      test_hash = {:performer => 'Steve Mac', :title => 'Essential Mix (2008-10-25) [TMB]'}
      assert_equal(test_hash, @sheet[:cuesheet])
    end
    
    should 'return list of hashes for cuesheet data' do
      test_hash = {:performer => "Essential Mix", :title => "Intro", :index => [0, 0, 0], :track => 1}
      test_hash2 = {:performer => "Marc Houle", :title => "Meatier Shower", :index => [1, 41, 13], :track => 2}
      assert_equal test_hash, @sheet[:tracks][0]
      assert_equal test_hash2, @sheet[:tracks][1]
    end

    should 'validate regexp tracks' do
      assert_equal 35, @sheet[:tracks].size
      @sheet[:tracks].each do |track|
        assert_equal(4, track.size)
      end
      assert_equal('Surkin', @sheet[:tracks][34][:performer])
    end

 end

#  should 'load cuesheet into database' do
#    Cuesheet.load_from_file('test/fixtures/test.cue')
#    @cuesheet = find_by_performer('Steve Mac')
#    assert @cuesheet
#    assert_equal('Steve Mac', @cuesheet.performer)
#    assert_equal('Intro', @cuesheet.songs[0])
#    assert_equal(0, @cuesheet.tracks[0].minutes)
#  end
#
end
