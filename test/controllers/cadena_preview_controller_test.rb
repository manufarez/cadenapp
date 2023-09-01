require "test_helper"

class CadenaPreviewControllerTest < ActionDispatch::IntegrationTest
  test "should get show" do
    get cadena_preview_show_url
    assert_response :success
  end
end
