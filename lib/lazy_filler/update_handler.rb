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
      strip_trailing_spaces(restore_emojis(tree.to_yaml(options || LazyFiller.yaml_options)))
    end

    def restore_emojis(yaml)
      yaml.gsub(EMOJI_REGEX) { |m| [m[-8..].to_i(16)].pack("U") }
    end

    def strip_trailing_spaces(yaml)
      yaml.gsub(TRAILING_SPACE_REGEX, "")
    end
  end
end
