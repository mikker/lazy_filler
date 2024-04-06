module LazyFiller
  class Middleware
    def initialize(app)
      @app = app
    end

    def call(env)
      if UpdateHandler.matches?(env)
        return UpdateHandler.call(env)
      end

      @app.call(env)
    rescue ActionView::Template::Error => e
      ErrorPage.render(e)
    end
  end
end
