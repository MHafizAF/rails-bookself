require_relative "boot"

require "rails/all"

Bundler.require(*Rails.groups)

module Bookself
  class Application < Rails::Application
    config.time_zone = 'Jakarta'
    config.load_defaults 7.0
    config.api_only = true
  end
end
