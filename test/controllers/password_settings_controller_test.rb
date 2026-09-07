require 'test_helper'

class PasswordSettingsControllerTest < ActionDispatch::IntegrationTest
  test 'should get edit' do
    get password_settings_edit_url
    assert_response :success
  end

  test 'should get update' do
    get password_settings_update_url
    assert_response :success
  end
end
