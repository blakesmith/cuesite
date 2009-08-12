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

  should 'POST create' do
    f = File.open('test/fixtures/test.cue')
    flexstub(f).should_receive(:original_filename).and_return('test.cue')
    post :create, :cue_file => f
    assert_response :redirect
  end
  
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

  should 'GET export' do
    stub = flexstub(@controller)
    stub.should_receive(:send_data).times(1)
    flexstub(@controller).should_receive(:render)
    cue = create_cuesheet
    get :export, :id => cue.id
    assert_response :success
  end

end
