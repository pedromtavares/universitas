# this is required for running on Linode instance that hosts Universitas
if ENV['RAILS_ENV'] == "production"
  require 'yaml'
  YAML::ENGINE.yamler= 'syck'
end
require 'rubygems'

# Set up gems listed in the Gemfile.
gemfile = File.expand_path('../../Gemfile', __FILE__)
begin
  ENV['BUNDLE_GEMFILE'] = gemfile
  require 'bundler'
  Bundler.setup
rescue Bundler::GemNotFound => e
  STDERR.puts e.message
  STDERR.puts "Try running `bundle install`."
  exit!
end if File.exist?(gemfile)
