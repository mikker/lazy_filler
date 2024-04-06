require "test_helper"

class LazyFiller::UpdateHandlerTest < ActionDispatch::IntegrationTest
  setup do
    File.open("test/dummy/config/locales/test.yml", "w") do |f|
      f << "test:\n"
    end
  end

  test("it updates a locale file") do
    post "/__lazy_filler", params: {"key" => "test.some.deeply.nested.key", "value" => "omg we did it"}

    assert_response :success
    assert_equal "omg we did it", I18n.t("some.deeply.nested.key", locale: "test")
  end
end
