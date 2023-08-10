# frozen_string_literal: true

source 'https://rubygems.org'

# Specify your gem's dependencies in ruby_apm.gemspec
gemspec

gem 'rake', '~> 12.0'

group :test do
  gem 'rspec', '~> 3.0'
end

group :development, :test do
  gem 'rubocop', require: false
  gem 'rubocop-rake', require: false
  gem 'rubocop-rspec', require: false
end
