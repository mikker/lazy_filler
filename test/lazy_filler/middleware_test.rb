require "test_helper"

class LazyFiller::MiddlewareTest < ActionDispatch::IntegrationTest
  test("it inserts itself") do
    assert_includes Rails.application.middleware, LazyFiller::Middleware
  end

  test("it catches missing tranlation exceptions") do
    get "/"
    # stub expect ErrorPage.render or use some adapter pattern
  end

  test("it can update a locale file") do
    post "/__lazy_filler"
  end
end
