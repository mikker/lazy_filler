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

    private

    def engine
      Erubi::Engine.new(File.read(template_path))
    end

    def template_path
      File.expand_path("templates/error_page.erb", __dir__)
    end
  end
end
