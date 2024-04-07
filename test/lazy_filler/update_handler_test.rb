require "test_helper"

class LazyFiller::UpdateHandlerTest < ActionDispatch::IntegrationTest
  TEST_LOCALE_FILE = "test/dummy/config/locales/test.yml"

  setup do
    File.open(TEST_LOCALE_FILE, "w") { |f| f << "test:\n" }
  end

  test("it updates a locale file") do
    post(
      "/__lazy_filler",
      params: {
        "key" => "test.some.deeply.nested.key",
        "value" => "omg we did it"
      }
    )

    assert_response :success
    assert_equal({"status" => "ok"}, JSON.parse(response.body))
    assert_equal "omg we did it", I18n.t("some.deeply.nested.key", locale: "test")
  end
end
