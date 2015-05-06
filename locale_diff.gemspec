$:.push File.expand_path("../lib", __FILE__)

# Maintain your gem's version:
require "locale_diff/version"

# Describe your gem and declare its dependencies:
Gem::Specification.new do |s|
  s.name        = "locale_diff"
  s.version     = LocaleDiff::VERSION
  s.authors     = ["ChrisSandison"]
  s.email       = ["chris.sandison@gmail.com"]
  s.homepage    = "TODO"
  s.summary     = "TODO: Summary of LocaleDiff."
  s.description = "TODO: Description of LocaleDiff."
  s.license     = "MIT"

  s.files = Dir["{app,config,db,lib}/**/*", "MIT-LICENSE", "Rakefile", "README.rdoc"]
  s.test_files = Dir["spec/**/*"]

  s.add_dependency "rails", "~> 4.1.10"

  s.add_development_dependency "rails", "~> 4.1.10"
  s.add_development_dependency "sqlite3"
  s.add_development_dependency "pry-nav"
  s.add_development_dependency "cucumber"
  s.add_development_dependency "aruba"
  s.add_development_dependency 'rspec-rails'
  s.add_development_dependency 'capybara'
  s.add_development_dependency 'factory_girl_rails'
  s.add_development_dependency 'better_errors'
  s.add_dependency "activesupport"
  s.add_dependency "thor"
end
