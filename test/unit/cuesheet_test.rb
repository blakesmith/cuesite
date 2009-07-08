require 'test_helper'

class CuesheetTest < ActiveSupport::TestCase
  fixtures :cuesheets

  should 'load fixtures' do
    cuesheet = cuesheets(:steve_mac)
    assert cuesheet
    assert_equal cuesheet.performer, 'Steve Mac'
    assert_equal cuesheet.title, 'Essential Mix (2008-10-25) [TMB]'
  end

  should 'load fixture replacement' do
    cuesheet = create_cuesheet
    assert cuesheet
  end

end
