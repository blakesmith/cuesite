require 'test_helper'

class CuesheetControllerTest < ActionController::TestCase
  # Replace this with your real tests.
  test "the truth" do
    assert true
  end

  should 'GET index' do
    get :index
    assert_response :success
    assert_template 'list'
  end

  should 'GET new' do
    get :new
    assert_response :success
    assert_template 'new'
  end

 # should 'POST create' do
 #   f = File.open('test/fixtures/test.cue')
 #   post :create, :cue_file => f
 #   assert_response :success
 #   assert_template 'show'
 # end
  
  should 'GET show' do
    cue = create_cuesheet
    get :show, :id => cue.id
    assert_response :success
    assert_template 'show'
  end

  should 'DESTROY cuesheet' do
    cue = create_cuesheet
    delete :destroy, :id => cue.id
    assert_response :success
    assert_template 'list'
    assert_select 'div.success', :text => 'Cuesheet successfully removed!'
  end

end
