require "lazy_filler/version"
require "lazy_filler/railtie"
require "lazy_filler/middleware"
require "lazy_filler/error_page"
require "lazy_filler/update_handler"

module LazyFiller
  cattr_accessor :yaml_options, default: {line_width: -1}
end
