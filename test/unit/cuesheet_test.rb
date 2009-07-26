require 'test_helper'

class CuesheetTest < ActiveSupport::TestCase

  should 'load fixture replacement' do
    cuesheet = create_cuesheet
    assert cuesheet
  end

  context 'load from file' do

    setup do
      @sheet = Cuesheet.parse_cue_file('test/fixtures/test.cue')
    end

    should 'return overall performer and title and file' do
      test_hash = {:performer => 'Steve Mac', :title => 'Essential Mix (2008-10-25) [TMB]', :file => 'Essential Mix - 2008-10-25 - Steve Mac.mp3'}
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

  should 'load cuesheet into database' do
    Cuesheet.load_from_file('test/fixtures/test.cue')
    @cuesheet = Cuesheet.find_by_cue_file('test.cue')
    assert @cuesheet
    assert_equal('Steve Mac', @cuesheet.performer)
    assert_equal('Essential Mix (2008-10-25) [TMB]', @cuesheet.title)
    assert_equal('test.cue', @cuesheet.cue_file)
    assert_equal('Essential Mix - 2008-10-25 - Steve Mac.mp3', @cuesheet.file)
    assert_equal('Intro', @cuesheet.tracks[0].song.title)
    assert_equal(1, @cuesheet.tracks[0].track_num)
    assert_equal('Surkin', @cuesheet.tracks[34].song.performer)
    assert_equal('White Knight Two (Mac Re Edit)', @cuesheet.tracks[34].song.title)
    assert_equal(0, @cuesheet.tracks[0].minutes)
  end

  should 'cuesheet to file from database with songs' do
    file = 'test/fixtures/test.cue'
    fixture = File.open(file).read
    Cuesheet.load_from_file('test/fixtures/test.cue')
    cue = Cuesheet.find_by_cue_file('test.cue')
    assert_equal(fixture, cue.to_cuesheet)
  end

end
