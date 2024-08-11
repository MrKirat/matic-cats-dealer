# frozen_string_literal: true

source 'https://rubygems.org'
git_source(:github) { |repo| "https://github.com/#{repo}.git" }

ruby file: '.ruby-version'

gem 'rails', '~> 6.1.7', '>= 6.1.7.8'

gem 'blueprinter'
gem 'bootsnap', '>= 1.4.4', require: false
gem 'httparty'
gem 'jbuilder', '~> 2.7'
gem 'puma', '~> 5.0'
gem 'sqlite3', '~> 1.4'

gem 'dry-monads'
gem 'dry-validation'

group :development, :test do
  gem 'byebug', platforms: %i[mri mingw x64_mingw]
  gem 'dotenv'
  gem 'factory_bot_rails'
  gem 'faker'

  gem 'rubocop',             require: false
  gem 'rubocop-factory_bot', require: false
  gem 'rubocop-rails',       require: false
  gem 'rubocop-rspec',       require: false
end

group :development do
  gem 'listen', '~> 3.3'
  gem 'spring'
end

group :test do
  gem 'rspec-rails', '~> 6.1.0'
  gem 'vcr'
  gem 'webmock'
end

# Windows does not include zoneinfo files, so bundle the tzinfo-data gem
gem 'tzinfo-data', platforms: %i[mingw mswin x64_mingw jruby]
