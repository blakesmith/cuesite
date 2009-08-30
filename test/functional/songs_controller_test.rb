require 'test_helper'

class SongsControllerTest < ActionController::TestCase

  should 'GET show' do
    song = create_song
    get :show, :id => song.id
    assert_response :success
    assert_template 'show'
    assert assigns(:song)
    assert assigns(:remixes)
  end

  should 'PUT update' do
    song = create_song
    track = create_track :song => song
    xhr :put, :update, :id => song.id, :song => song, :track => track.id
    assert_response :success
    assert_select_rjs :hide, "edit_song_#{song.id}"
    assert_select_rjs :show, "display_song_#{song.id}"
  end
end
