module LazyFiller
  class UpdateHandler
    def initialize(env)
      @env = env
    end

    attr_reader :env

    def call
      params = Rack::Request.new(env).params

      key_path = params["key"].split(".")
      locale = key_path.first
      yaml = YAML.safe_load_file(locale_file(locale))
      value = params["value"]
      update = key_path.reverse.reduce(value) do |prev, key|
        {key => prev}
      end

      updated_yaml = yaml.deep_merge(update)

      File.open(locale_file(locale), "w") do |f|
        f << YAML.dump(updated_yaml)
      end

      [200, {"Content-Type" => "application/json"}, ["{\"status\": \"ok\"}"]]
    end

    def self.call(env)
      new(env).call
    end

    def self.matches?(env)
      env["PATH_INFO"] == "/__lazy_filler"
    end

    private

    def locale_file(locale)
      File.expand_path("config/locales/#{locale}.yml", Rails.root)
    end
  end
end
