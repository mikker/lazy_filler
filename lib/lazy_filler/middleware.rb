module LazyFiller
  class Middleware
    def initialize(app, update_handler: UpdateHandler, error_page: ErrorPage)
      @app = app
      @update_handler = update_handler
      @error_page = error_page
    end

    def call(env)
      if @update_handler.matches?(env)
        return @update_handler.call(env)
      elsif env["PATH_INFO"] == "/__lazy_filler/styles.css"
        return [
          200,
          {"Content-Type" => "text/css"},
          [css]
        ]
      end

      @app.call(env)
    rescue ActionView::Template::Error => e
      if e.message.match?(/translation missing:/i)
        Rails.logger.debug("LazyFiller: Intercepted #{e.inspect}")
        Rails.logger.debug("\t#{e.message}")
        return @error_page.render(e)
      end

      raise
    end

    def css
      @css ||= File.read(File.expand_path("../templates/styles.css", __FILE__))
    end
  end
end
