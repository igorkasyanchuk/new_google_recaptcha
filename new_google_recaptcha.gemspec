$:.push File.expand_path("lib", __dir__)

# Maintain your gem's version:
require "new_google_recaptcha/version"

# Describe your gem and declare its dependencies:
Gem::Specification.new do |s|
  s.name        = "new_google_recaptcha"
  s.version     = NewGoogleRecaptcha::VERSION
  s.authors     = ["Igor Kasyanchuk", "rubyconvict"]
  s.email       = ["igorkasyanchuk@gmail.com"]
  s.homepage    = "https://github.com/igorkasyanchuk/new_google_recaptcha"
  s.summary     = "Google reCAPTCHA v3 + Rails"
  s.description = "Google reCAPTCHA v3 + Rails (integration)"
  s.license     = "MIT"

  s.files = Dir["{app,config,db,lib}/**/*", "MIT-LICENSE", "Rakefile", "README.md"]

  s.add_dependency "rails", ">= 4.2.0"

  s.add_development_dependency "sqlite3", '>= 1.3'
  s.add_development_dependency "byebug", '>= 10.0'
  s.add_development_dependency "webmock", '>= 3.5'
  s.add_development_dependency "mocha", '~> 0.14.0'
  s.add_development_dependency "redis-store-testing"
  s.add_development_dependency "connection_pool", '~> 1.2.0'
  s.add_development_dependency "appraisal"
end
