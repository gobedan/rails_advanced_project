require_relative 'boot'

require 'rails/all'

# Require the gems listed in Gemfile, including any gems
# you've limited to :test, :development, or :production.
Bundler.require(*Rails.groups)

module Qna
  class Application < Rails::Application
    config.before_configuration do 
      env_file = Rails.root.join('config/local_env.yml')
      if File.exist?(env_file)
        YAML.safe_load(File.open(env_file)).each do |key, value| 
          ENV[key.to_s] = value
        end
      end 
    end
    # Initialize configuration defaults for originally generated Rails version.
    config.load_defaults 6.0

    # Settings in config/environments/* take precedence over those specified here.
    # Application configuration can go into files in config/initializers
    # -- all .rb files in that directory are automatically loaded after loading
    # the framework and any gems in your application.
    config.generators do |g| 
      g.test_framefork :rspec,
                       view_specs: false,
                       helper_specs: false,
                       request_specs: false 
    end
  end
end
