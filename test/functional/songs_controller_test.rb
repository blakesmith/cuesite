require 'test_helper'

class SongsControllerTest < ActionController::TestCase

  should 'GET show' do
    song = create_song
    get :show, :id => song.id
    assert_response :success
    assert_template 'show'
  end
end
