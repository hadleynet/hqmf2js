source "http://rubygems.org"

group :assets do
  gem 'sass-rails'
  gem 'coffee-rails'
  gem 'uglifier'
end

gem "hquery-patient-api", :git => 'http://github.com/hquery/patientapi.git', :branch => 'develop'

gem 'nokogiri'
gem 'sprockets'
gem 'coffee-script'
gem 'uglifier'
gem 'tilt'
gem 'rake'
gem 'pry'

group :test do
  gem 'minitest'
  gem 'turn', :require => false
  gem 'cover_me', '~> 1.2.0'
  gem 'awesome_print', :require => 'ap'
  
  platforms :ruby do
    gem "therubyracer", :require => 'v8'
  end
  
  platforms :jruby do
    gem "therubyrhino"
  end
end