require 'test_helper'

class RegistrationsControllerTest < ActionDispatch::IntegrationTest
  test 'should get complete' do
    get registrations_complete_url
    assert_response :success
  end
end
