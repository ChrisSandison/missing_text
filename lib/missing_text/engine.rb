require 'bootstrap-sass'
require 'haml'
require 'font-awesome-rails'
require 'jquery-rails'
require 'jquery-ui-rails'

module MissingText
  class Engine < ::Rails::Engine
    isolate_namespace MissingText

    initializer "missing_text.load_app_root" do |app|
      MissingText.app_root = app.root
    end

    config.generators do |g|
      g.test_framework      :rspec,        :fixture => false
      g.fixture_replacement :factory_girl, :dir => 'spec/factories'
      g.assets false
      g.helper false
    end
    
  end
end
