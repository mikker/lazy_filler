require "test_helper"

class ErrorPageTest < ActionDispatch::IntegrationTest
  test("renders error page") do
    ex = Exception.new("translation missing: en.hello")
    subject = LazyFiller::ErrorPage.new(ex)

    pp subject.render
  end
end
