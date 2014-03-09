require File.expand_path('../boot', __FILE__)

require 'rails/all'
require 'active_record/connection_adapters/postgis_adapter/railtie'

# Require the gems listed in Gemfile, including any gems
# you've limited to :test, :development, or :production.
Bundler.require(:default, Rails.env)

module Bikepark
  class Application < Rails::Application
    config.encoding = "utf-8"
    config.filter_parameters += [:password]
    config.active_support.escape_html_entities_in_json = true
    config.active_record.whitelist_attributes = true
    config.assets.enabled = true
    config.assets.version = '1.0'
  end

  class ActiveRecordOverrideRailtie < Rails::Railtie
    initializer "active_record.initialize_database.override" do |app|

      ActiveSupport.on_load(:active_record) do
        if url = ENV['DATABASE_URL']
          ActiveRecord::Base.connection_pool.disconnect!
          parsed_url = URI.parse(url)
          config =  {
            adapter:             'postgis',
            host:                parsed_url.host,
            encoding:            'unicode',
            database:            parsed_url.path.split("/")[-1],
            port:                parsed_url.port,
            username:            parsed_url.user,
            password:            parsed_url.password
          }
          establish_connection(config)
        end
      end
    end
  end
end
