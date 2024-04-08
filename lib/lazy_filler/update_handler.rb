module LazyFiller
  class UpdateHandler
    EMOJI_REGEX = /\\u[\da-f]{8}/i.freeze
    TRAILING_SPACE_REGEX = / $/.freeze

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
        f << dump(updated_yaml)
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

    def dump(tree, options = nil)
      tree.to_yaml(options || LazyFiller.yaml_options)
    end
  end
end
