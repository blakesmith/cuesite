require 'test_helper'

class SongTest < ActiveSupport::TestCase

  should 'parse_remix paren' do
    song = create_song :title => 'song (remix)', :remix => nil
    song.parse_remix
    assert_equal('remix', song.remix)
    assert_equal('song', song.title)
  end

  should 'parse_remix paren multiple words' do
    song = create_song :title => 'song that rocks (original remix)', :remix => nil
    song.parse_remix
    assert_equal('original remix', song.remix)
    assert_equal('song that rocks', song.title)
  end

  should 'parse_remix bracket' do
    song = create_song :title => 'song [remix]', :remix => nil
    song.parse_remix
    assert_equal('remix', song.remix)
    assert_equal('song', song.title)
  end

  should 'parse_remix bracket multiple words' do
    song = create_song :title => 'song that rocks [original remix]', :remix => nil
    song.parse_remix
    assert_equal('original remix', song.remix)
    assert_equal('song that rocks', song.title)
  end

  should 'parse_remix strip all parens' do
    song = create_song :title => 'song that rocks (original remix)(blake edit)', :remix => nil
    song.parse_remix
    assert_equal('original remix, blake edit', song.remix)
    assert_equal('song that rocks', song.title)
  end

  should 'parse_remix strip all parens not together' do
    song = create_song :title => 'song that (original remix) rocks (blake edit)', :remix => nil
    song.parse_remix
    assert_equal('original remix, blake edit', song.remix)
    assert_equal('song that rocks', song.title)
  end

  should 'parse_remix strip all brackets' do
    song = create_song :title => 'song that rocks [original remix][blake edit]', :remix => nil
    song.parse_remix
    assert_equal('original remix, blake edit', song.remix)
    assert_equal('song that rocks', song.title)
  end

  should 'parse_remix strip all brackets not together' do
    song = create_song :title => 'song that [original remix] rocks [blake edit]', :remix => nil
    song.parse_remix
    assert_equal('original remix, blake edit', song.remix)
    assert_equal('song that rocks', song.title)
  end

  should 'print remix' do
    song = create_song :remix => 'original remix'
    assert_equal(' (original remix)', song.print_remix)
  end

  should 'not print remix if remix is nil' do
    song = create_song :remix => nil
    assert_equal('', song.print_remix)
  end

  should 'named_scope has_remix' do
    song = create_song :remix => 'Original Mix'
    song2 = create_song :remix => nil
    all = Song.has_remix
    assert all.include?(song)
    assert ! all.include?(song2)
  end

  should 'named_scope no_remix' do
    song = create_song :remix => 'Original Mix'
    song2 = create_song :remix => nil
    all = Song.no_remix
    assert ! all.include?(song)
    assert all.include?(song2)
  end

  should 'remix_count, no remix' do
    song = create_song :remix => nil
    assert_equal(0, song.remix_count)
  end

  should 'remix_count, 1 remix' do
    song = create_song :remix => nil
    song2 = create_song :remix => 'House Mix'
    assert_equal(1, song.remix_count)
  end

  should 'all_remixes, no remix' do
    song = create_song :remix => nil
    assert_equal([], song.all_remixes)
  end

  should 'all_remixes, 2 remix' do
    song = create_song :remix => nil
    song2 = create_song :remix => 'House Mix'
    song3 = create_song :remix => 'Original Mix'
    assert_same_elements([song2, song3], song.all_remixes)
  end

  should 'all_cuesheets' do
    cuesheet = create_cuesheet
    cuesheet2 = create_cuesheet
    song = create_song 
    track = create_track :song => song, :cuesheet => cuesheet
    track2 = create_track :song => song, :cuesheet => cuesheet2
    cues = song.all_cuesheets

    assert_same_elements [cuesheet, cuesheet2], cues
  end

end
