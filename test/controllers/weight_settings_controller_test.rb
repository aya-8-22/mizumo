require 'test_helper'

class WeightSettingsControllerTest < ActionDispatch::IntegrationTest
  test 'should get edit' do
    get weight_settings_edit_url
    assert_response :success
  end

  test 'should get update' do
    get weight_settings_update_url
    assert_response :success
  end
end
