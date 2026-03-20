require_relative 'boot'

require 'rails/all'

# Workaround for Ruby 4.0 compatibility with Rails 7.1.
# Ruby 4.0 changed initialization behavior causing setup_main_autoloader
# (which freezes ActiveSupport::Dependencies.autoload_paths) to run before
# all engines have added their paths via set_autoload_paths, resulting in a
# FrozenError. This workaround can be removed when upgrading to a Rails
# version with native Ruby 4.0 support (likely Rails 8.1+).
if Gem::Version.new(RUBY_VERSION) >= Gem::Version.new('4.0')
  ActiveSupport::Dependencies.autoload_paths.define_singleton_method(:freeze) { self }
  ActiveSupport::Dependencies.autoload_once_paths.define_singleton_method(:freeze) { self }
end

# Require the gems listed in Gemfile, including any gems
# you've limited to :test, :development, or :production.
Bundler.require(*Rails.groups)

module BacklogManager
  # Config for entire application
  class Application < Rails::Application
    # Initialize configuration defaults for originally generated Rails version.
    config.load_defaults 7.0

    # Load the lib directoryon boot
    config.autoload_paths << Rails.root.join('lib')

    # Configuration for the application, engines, and railties goes here.
    #
    # These settings can be overridden in specific environments using the files
    # in config/environments, which are processed later.
    #
    # config.time_zone = "Central Time (US & Canada)"
    # config.eager_load_paths << Rails.root.join("extras")

    # Background jobs
    config.active_job.queue_adapter = :delayed_job
  end
end
