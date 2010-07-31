HEROKU = ENV['USER'].match(/^repo\d+/)

source 'http://rubygems.org'

gem 'rails', '3.0.0.beta4'

# Bundle edge Rails instead:
# gem 'rails', :git => 'git://github.com/rails/rails.git'

gem 'mysql'
gem 'mongrel'
gem "mongrel_experimental"
gem 'haml'
gem 'inherited_resources', '1.1.2'
gem 'devise', '1.1.rc2'
gem 'hpricot'
gem 'friendly_id'
#gem 'pg'
#gem 'heroku', '1.9.13'

unless HEROKU
	group :test do
	  gem "rspec"
	  gem "rspec-rails",      ">= 2.0.0.beta"
	  gem "machinist",        :git => "git://github.com/notahat/machinist.git"
	  gem "faker"
	  gem "ZenTest"
	  gem "autotest"
	  gem "autotest-rails"
	  gem "cucumber",         :git => "git://github.com/aslakhellesoy/cucumber.git"
	  gem "database_cleaner", :git => 'git://github.com/bmabey/database_cleaner.git'
	  gem "cucumber-rails",   :git => "git://github.com/aslakhellesoy/cucumber-rails.git"
	  gem "capybara"
	  gem "capybara-envjs"
	  gem "launchy"
	  gem "ruby-debug"
	  gem 'factory_girl_rails'
	end
end

# Use unicorn as the web server
# gem 'unicorn'

# Deploy with Capistrano
# gem 'capistrano'

# To use debugger
# gem 'ruby-debug'

# Bundle the extra gems:
# gem 'bj'
# gem 'nokogiri', '1.4.1'
# gem 'sqlite3-ruby', :require => 'sqlite3'
# gem 'aws-s3', :require => 'aws/s3'

# Bundle gems for certain environments:
# gem 'rspec', :group => :test
# group :test do
#   gem 'webrat'
# end
