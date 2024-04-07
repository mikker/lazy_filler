require "test_helper"

class LazyFiller::MiddlewareTest < ActionDispatch::IntegrationTest
  class FakeHandler
    def self.matches?(env)
      env["PATH_INFO"] == "/plz_match"
    end

    def self.call(_env)
      [123, {}, ["so fake"]]
    end
  end

  class FakeErrorPage
    def self.render(_exception)
      [321, {}, ["mega fake"]]
    end
  end

  setup do
    @app = -> (_env) { [200, {}, ["ok"]] }
  end

  def subject
    LazyFiller::Middleware.new(
      @app,
      update_handler: FakeHandler,
      error_page: FakeErrorPage
    )
  end

  test("it inserts itself") do
    assert_includes Rails.application.middleware, LazyFiller::Middleware
  end

  test("calls through") do
    status, headers, body = subject.call({})

    assert_equal(200, status)
    assert_equal({}, headers)
    assert_equal(["ok"], body)
  end

  test("catches template errors and displays error page") do
    @app = -> (_) { raise template_error }

    status, headers, body = subject.call({})

    assert_equal(321, status)
    assert_equal(["mega fake"], body)
  end

  test("handles update requests") do
    status, headers, body = subject.call({"PATH_INFO" => "/plz_match"})

    assert_equal(123, status)
    assert_equal(["so fake"], body)
  end
end
