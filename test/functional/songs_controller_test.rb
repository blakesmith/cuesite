require 'test_helper'

class SongsControllerTest < ActionController::TestCase

  should 'GET show' do
    cuesheet = create_cuesheet
    song = create_song
    get :show, :id => song.id, :from => cuesheet.id
    assert_response :success
    assert_template 'show'
    assert assigns(:song)
    assert assigns(:remixes)
    assert assigns(:cuesheets)
    assert assigns(:cuesheet)
  end

  should 'PUT update' do
    song = create_song
    track = create_track :song => song
    cuesheet = create_cuesheet
    xhr :put, :update, :id => song.id, :song => song, :track => track.id, :from => cuesheet.id
    assert_response :success
    assert_select_rjs :replace, "song_#{song.id}"
  end

  should 'PUT update new song' do
    song = create_song :performer => 'blah', :title => 'awesome'
    track = create_track :song => song
    cuesheet = create_cuesheet
    xhr :put, :update, :id => song.id, :song => {:performer => 'blah2', :title => 'awesome2'}, :track => track.id, :from => cuesheet.id
    assert_response :success
    track.reload
    assert_equal 'blah2', track.song.performer
    assert_equal 'awesome2', track.song.title
    assert track.song_id != song.id
  end

  should 'PUT update attatch to other existing song' do
    song = create_song :performer => 'blah', :title => 'awesome'
    song2 = create_song :performer => 'blah2', :title => 'awesome2'
    track = create_track :song => song
    cuesheet = create_cuesheet
    xhr :put, :update, :id => song.id, :song => {:performer => 'blah2', :title => 'awesome2'}, :track => track.id, :from => cuesheet.id
    assert_response :success
    track.reload
    assert_equal 'blah2', track.song.performer
    assert_equal 'awesome2', track.song.title
    assert track.song_id == song2.id
  end
end
