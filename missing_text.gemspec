$:.push File.expand_path("../lib", __FILE__)

# Maintain your gem's version:
require "missing_text/version"

# Describe your gem and declare its dependencies:
Gem::Specification.new do |s|
  s.name        = "missing_text"
  s.version     = MissingText::VERSION
  s.authors     = ["ChrisSandison"]
  s.email       = ["chris.sandison@gmail.com"]
  s.homepage    = "https://github.com/ChrisSandison/missing_text"
  s.summary     = "Detects translations missing in your applications' locale files"
  s.description = "MissingText is a rails engine for detecting missing translations from your locale files. The web interface allows full visiblity of missing translations by file, allowing you to revisit and clear sessions."
  s.license     = "MIT"

  s.files = Dir["{app,config,db,lib}/**/*", "MIT-LICENSE", "Rakefile", "README.rdoc"]
  s.test_files = Dir["spec/**/*"]

  s.add_dependency "rails", '>= 4.1.8'
  s.add_dependency "activesupport", '>= 4.0.2'
  s.add_dependency 'coffee-rails', '>= 4.0.1'
  s.add_dependency 'font-awesome-rails', ['>= 3.0', '< 5']
  s.add_dependency 'haml', '~> 4.0'
  s.add_dependency 'jquery-rails', ['>= 3.0', '< 5']
  s.add_dependency 'jquery-ui-rails', '~> 5.0'
  s.add_dependency 'bootstrap-sass', '~> 3.3', '>= 3.1.0'
  s.add_dependency 'sass-rails', '>= 4.0.5'

  s.add_development_dependency 'sqlite3'
  s.add_development_dependency 'pry-nav'
  s.add_development_dependency 'rspec-rails'
  s.add_development_dependency 'capybara'
  s.add_development_dependency 'factory_girl_rails'
  s.add_development_dependency 'better_errors'
  s.add_development_dependency 'awesome_print'
  s.add_development_dependency "html2haml"
  s.add_development_dependency "faker"
end



