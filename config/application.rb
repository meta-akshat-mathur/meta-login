require File.expand_path('../boot', __FILE__)

require 'rails/all'

# Require the gems listed in Gemfile, including any gems
# you've limited to :test, :development, or :production.
Bundler.require(*Rails.groups)

module MetaLogin
  class Application < Rails::Application
  # Settings in config/environments/* take precedence over those specified here.
  # Application configuration should go into files in config/initializers
  # -- all .rb files in that directory are automatically loaded.

  # Set Time.zone default to the specified zone and make Active Record auto-convert to this zone.
  # Run "rake -D time" for a list of tasks for finding time zone names. Default is UTC.
  config.time_zone = 'Kolkata'

  # The default locale is :en and all translations from config/locales/*.rb,yml are auto loaded.
  # config.i18n.load_path += Dir[Rails.root.join('my', 'locales', '*.{rb,yml}').to_s]
  # config.i18n.default_locale = :de

  config.assets.precompile += %w[*.png *.jpg *.jpeg *.gif]

  config.exceptions_app = self.routes

  config.autoload_paths += %W(#{config.root}/app/uploaders)
  #notification
  config.autoload_paths += Dir["#{config.root}/lib/mn_authorizers/**/"]
  # offer-letter
  config.autoload_paths += %W(#{config.root}/lib/)
  config.autoload_paths += %W(#{config.root}/lib/template_evaluation)
  config.autoload_paths += %W(#{config.root}/lib/quiz)

  # config.assets.paths << Rails.root.join("app", "assets", "images", "img")

  # allow framing for all website
  # config.action_dispatch.default_headers['X-Frame-Options'] = 'ALLOWALL'

  # For Commpression
  config.middleware.use Rack::Deflater
  # For Commpression
  end
end
