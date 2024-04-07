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
      end

      @app.call(env)
    rescue ActionView::Template::Error => e
      @error_page.render(e)
    end
  end
end
