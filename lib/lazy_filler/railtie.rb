module LazyFiller
  class Railtie < ::Rails::Railtie
    initializer("lazy_filler.configure_rails_initialization") do
      if use_lazy_filler?
        insert_middleware
        # BetterErrors.logger = Rails.logger
        # BetterErrors.application_root = Rails.root.to_s
      end
    end

    def insert_middleware
      if defined?(ActionDispatch::DebugExceptions)
        app.middleware.insert_after(ActionDispatch::DebugExceptions, LazyFiller::Middleware)
      else
        app.middleware.use(BetterErrors::Middleware)
      end
    end

    def use_lazy_filler?
      return false if Rails.env.production?
      return false if !app.config.consider_all_requests_local

      true
    end

    def app
      Rails.application
    end
  end
end
