require "test_helper"

class PlatformFamiliesControllerTest < ActionDispatch::IntegrationTest
  test "should get index" do
    get platform_families_index_url
    assert_response :success
  end

  test "should get show" do
    get platform_families_show_url
    assert_response :success
  end
end
