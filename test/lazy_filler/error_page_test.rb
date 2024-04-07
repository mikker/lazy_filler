require "test_helper"

class ErrorPageTest < ActionDispatch::IntegrationTest
  def subject
    ex = Exception.new("translation missing: en.hello")
    LazyFiller::ErrorPage.new(ex)
  end

  test("renders error page") do
    status, headers, body = subject.render

    assert_equal(500, status)
    assert_equal({"Content-Type" => "text/html"}, headers)
    assert_match(/<!DOCTYPE html>/, body.first)
  end

  test("key") do
    assert_equal("en.hello", subject.key)
  end

  test("key without locale") do
    assert_equal("hello", subject.key_without_locale)
  end

  test("title") do
    assert_equal("translation missing: en.hello", subject.title)
  end

  test("locale") do
    assert_equal(:en, subject.locale)
  end

  test("other translations") do
    translations = subject.other_translations
    assert_equal({test: nil, da: nil}, translations)
  end

  test("locale file") do
    assert_equal("en.yml", subject.locale_file)
  end
end
