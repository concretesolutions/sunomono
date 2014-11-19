source 'https://rubygems.org'

# Specify your gem's dependencies in cs-bdd.gemspec
gemspec

gem 'thor'
gem 'i18n'
gem 'json'
gem 'gherkin'

# calabash gems
gem 'calabash-common'
# Only for Linux
if RUBY_PLATFORM.include? 'linux'
  gem 'calabash-android'
else # Only for Mac. This gem will not be used in Windows
  gem 'calabash-cucumber'
end