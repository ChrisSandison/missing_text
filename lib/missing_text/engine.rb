require 'bootstrap-sass'
require 'haml'
require 'font-awesome-rails'
require 'jquery-rails'
require 'jquery-ui-rails'

module MissingText
  class Engine < ::Rails::Engine
    isolate_namespace MissingText

    # This will be needed for creating absolute file paths
    initializer "missing_text.load_app_root" do |app|
      MissingText.app_root = app.root
    end

    config.generators do |g|
      g.test_framework      :rspec,        :fixture => false
      g.fixture_replacement :factory_girl, :dir => 'spec/factories'
      g.assets false
      g.helper false
    end

    config.to_prepare do
      Dir.glob(Rails.root + "app/controllers/**/*_controller*.rb").each do |c|
        require_dependency(c)
      end
    end
    
  end
end
