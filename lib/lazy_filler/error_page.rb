module LazyFiller
  class ErrorPage
    def initialize(exception)
      @exception = exception
    end

    attr_reader :exception

    def render
      html = eval(engine.src, binding)

      [
        500,
        {"Content-Type" => "text/html"},
        [html]
      ]
    end

    def self.render(exception)
      new(exception).render
    end

    def key
      return nil unless matches = exception.message.match(/translation missing: (.*)/i)
      matches[1]
    end

    def key_without_locale
      key.sub(/\A\w+\./, "")
    end

    def title
      exception.message
    end

    def locale
      key.split(".").first.to_sym
    end

    def other_translations
      I18n
        .available_locales
        .reject { |k, _| k == locale }
        .each_with_object({}) do |locale, obj|
          obj[locale] = (I18n.t(key_without_locale, locale: locale) rescue nil)
        end
    end

    def locale_file
      "#{locale}.yml"
    end

    private

    def engine
      Erubi::Engine.new(File.read(template_path))
    end

    def template_path
      File.expand_path("templates/error_page.erb", __dir__)
    end
  end
end
