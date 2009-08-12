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

  should 'POST create no cue file' do
    post :create, :cue_file => nil
    assert_response :success
    assert_select 'div.error', :text => 'You didn\'t select a cuesheet to upload'
  end

  should 'POST create bad cue file' do
    f = File.open('test/fixtures/test.cue')
    flexstub(f).should_receive(:original_filename).and_return('test.cue')
    flexstub(Cuesheet).new_instances.should_receive(:save).and_return(nil)
    post :create, :cue_file => f
    assert_response :success
    assert_select 'div.error', :text => 'Cuesheet failed to upload'
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

  should 'DESTROY cuesheet failure' do
    flexstub(Cuesheet).new_instances(:find).should_receive(:delete).and_return(false)
    cue = create_cuesheet
    delete :destroy, :id => cue.id
    assert_response :success
    assert_template 'list'
    assert_select 'div.error', :text => 'Cuesheet failed to remove.'
  end

  should 'GET export' do
    stub = flexstub(@controller)
    stub.should_receive(:send_data, :render).times(1)
    cue = create_cuesheet
    get :export, :id => cue.id
    assert_response :success
  end

end
