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

  should 'print remix' do
    song = create_song :remix => 'original remix'
    assert_equal(' (original remix)', song.print_remix)
  end

  should 'not print remix if remix is nil' do
    song = create_song :remix => nil
    assert_equal('', song.print_remix)
  end

end
