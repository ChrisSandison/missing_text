$:.push File.expand_path("../lib", __FILE__)

# Maintain your gem's version:
require "missing_text/version"

# Describe your gem and declare its dependencies:
Gem::Specification.new do |s|
  s.name        = "missing_text"
  s.version     = MissingText::VERSION
  s.authors     = ["ChrisSandison"]
  s.email       = ["chris.sandison@gmail.com"]
  s.homepage    = "TODO"
  s.summary     = "TODO: Summary of MissingText."
  s.description = "TODO: Description of MissingText."
  s.license     = "MIT"

  s.files = Dir["{app,config,db,lib}/**/*", "MIT-LICENSE", "Rakefile", "README.rdoc"]
  s.test_files = Dir["spec/**/*"]

  s.add_dependency "rails", "~> 4.1.10"
  s.add_dependency "activesupport"
  s.add_dependency 'coffee-rails', '~> 4.0'
  s.add_dependency 'font-awesome-rails', ['>= 3.0', '< 5']
  s.add_dependency 'haml', '~> 4.0'
  s.add_dependency 'jquery-rails', ['>= 3.0', '< 5']
  s.add_dependency 'jquery-ui-rails', '~> 5.0'
  s.add_dependency 'bootstrap-sass', '~> 3.3.4'
  s.add_dependency 'sass-rails', ['>= 3.2']

  s.add_development_dependency "sqlite3"
  s.add_development_dependency "pry-nav"
  s.add_development_dependency 'rspec-rails'
  s.add_development_dependency 'capybara'
  s.add_development_dependency 'factory_girl_rails'
  s.add_development_dependency 'better_errors'
  s.add_development_dependency 'awesome_print'
  s.add_development_dependency "html2haml"
  s.add_development_dependency "faker"
end



