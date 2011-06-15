require 'test_helper'

class NavigationTest < ActiveSupport::IntegrationCase
  test "should be google" do
    visit "http://google.com"
    assert page.has_content?("Google")
  end
end
