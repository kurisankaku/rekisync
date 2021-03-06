source 'https://rubygems.org'


# Bundle edge Rails instead: gem 'rails', github: 'rails/rails'
gem 'rails', '~> 5.0.0', '>= 5.0.0.1'
# Use mysql as the database for Active Record
gem 'mysql2', '>= 0.3.18', '< 0.5'
# Use Puma as the app server
gem 'puma', '~> 3.0'
# Use SCSS for stylesheets
gem 'sass-rails', '~> 5.0'
# Use Uglifier as compressor for JavaScript assets
gem 'uglifier', '>= 1.3.0'
# Use CoffeeScript for .coffee assets and views
gem 'coffee-rails', '~> 4.2'
# See https://github.com/rails/execjs#readme for more supported runtimes
# gem 'therubyracer', platforms: :ruby

# Use jquery as the JavaScript library
gem 'jquery-rails'
# Build JSON APIs with ease. Read more: https://github.com/rails/jbuilder
gem 'jbuilder', '~> 2.5'
# Use Redis adapter to run Action Cable in production
gem 'redis', '~> 3.0'
gem 'redis-rails'
# Use ActiveModel has_secure_password
gem 'bcrypt', '~> 3.1.7'

# Use Capistrano for deployment
# gem 'capistrano-rails', group: :development

# logical delete.
gem 'paranoia', '~> 2.2'

# Simple, efficient background processing.
gem 'sidekiq'
# Seed gem.
gem 'seed-fu'
# Brings convention over configuration to your JSON generation.
gem 'active_model_serializers', '~> 0.10.0'
# log format.
gem 'lograge'
# markdown.
gem 'kramdown'

# oauth
gem 'omniauth'
gem 'omniauth-twitter'
gem "omniauth-google-oauth2"
gem "omniauth-facebook"

# Simple, Heroku-friendly Rails app configuration using ENV and a single YAML file
gem 'figaro'

# This gem provides a simple and extremely flexible way to upload files from Ruby applications.
gem 'carrierwave'
# A ruby wrapper for ImageMagick or GraphicsMagick command line.
gem 'mini_magick'

# A Scope & Engine based, clean, powerful, customizable and sophisticated paginator for Ruby webapps
gem 'kaminari'
# Draper adds an object-oriented layer of presentation logic to your Rails application.
gem 'draper', '3.0.0.pre1'

# FIXME When release version includes npm module, fetch from release, not master.
# gem 'sprockets', git: 'https://github.com/rails/sprockets.git', branch: 'master'

gem 'therubyracer'

group :development, :test do
  # Call 'byebug' anywhere in the code to stop execution and get a debugger console
  gem 'byebug', platform: :mri

  # Debug
  gem 'pry-rails'
  gem 'pry-doc'
  gem 'pry-byebug'
  gem 'pry-stack_explorer'

  # Test framework.
  gem 'rspec-rails', '~> 3.5'
  gem 'rspec-collection_matchers'
  gem 'factory_bot'
  gem 'factory_bot_rails'
end

group :development do
  # Access an IRB console on exception pages or by using <%= console %> anywhere in the code.
  gem 'web-console'
  gem 'listen', '~> 3.0.5'
  # Spring speeds up development by keeping your application running in the background. Read more: https://github.com/rails/spring
  gem 'spring'
  gem 'spring-watcher-listen', '~> 2.0.0'

  # Check N+1 query.
  gem 'bullet'
  # lint gem.
  gem 'rubocop'
end


group :test do
  gem 'faker'
  gem 'database_cleaner'
  gem 'json_expressions'
  gem 'timecop'
  gem 'webmock'
  gem 'sqlite3'
end

# Windows does not include zoneinfo files, so bundle the tzinfo-data gem
gem 'tzinfo-data', platforms: [:mingw, :mswin, :x64_mingw, :jruby]
