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

  should 'return list of hashes for cuesheet data from preloaded file (a string)' do
    @sheet = File.open('test/fixtures/test.cue').read
    @parsed = Cuesheet.parse_cue_file(@sheet)
    test_hash = {:performer => "Essential Mix", :title => "Intro", :index => [0, 0, 0], :track => 1}
    test_hash2 = {:performer => "Marc Houle", :title => "Meatier Shower", :index => [1, 41, 13], :track => 2}
    assert_equal test_hash, @parsed[:tracks][0]
    assert_equal test_hash2, @parsed[:tracks][1]
  end

  should 'load cuesheet into database as a file' do
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
    assert_equal('White Knight Two', @cuesheet.tracks[34].song.title)
    assert_equal('Luciano Mix / Mac Re Edit', @cuesheet.tracks[2].song.remix)
    assert_equal('Thrist', @cuesheet.tracks[2].song.title)
    assert_equal(0, @cuesheet.tracks[0].minutes)
  end

  should 'load cuesheet into database as a string' do
    file = 'test/fixtures/test.cue'
    @sheet = File.open(file).read
    Cuesheet.load_from_file(@sheet, file)
    @cuesheet = Cuesheet.find_by_cue_file('test.cue')
    assert @cuesheet
    assert_equal(@cuesheet.cue_file, 'test.cue')
  end

  should 'load accented, convert to UTF-8' do
    Cuesheet.load_from_file('test/fixtures/accented.cue')
    cuesheet = Cuesheet.find_by_cue_file('accented.cue')
    assert_equal 'Trentemøller', cuesheet.performer
  end

  context 'cuesheet from file' do

    setup do
      @cue = Cuesheet.load_from_file('test/fixtures/test.cue')
    end

    should 'cuesheet to file from database with songs' do
      file = 'test/fixtures/test.cue'
      fixture = File.open(file).read
      cue = Cuesheet.find_by_cue_file('test.cue')
      assert_equal(fixture, cue.to_cuesheet)
    end

    should 'return the same song for track with the same information' do
      @cue2 = Cuesheet.load_from_file('test/fixtures/test2.cue')
      assert_equal(@cue.tracks[0].song, @cue2.tracks[0].song)
    end

    should 'delete cuesheet with all tracks and songs' do
      id = @cue.id
      @cue.delete
      assert_nil(Cuesheet.find_by_id(id))
      assert_nil(Track.find_by_cuesheet_id(id))
      song = Song.find_by_performer_and_title_and_remix('Essential Mix', 'Intro', nil)
      assert_nil(song)
    end

    should 'delete not remove track' do
      track = create_track :song => @cue.tracks[0].song
      id = @cue.id
      @cue.delete
      assert_nil(Cuesheet.find_by_id(id))
      assert_nil(Track.find_by_cuesheet_id(id))
      song = Song.find_by_performer_and_title_and_remix('Essential Mix', 'Intro', nil)
      assert_not_nil(song)
    end

  end

end
